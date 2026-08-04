import os
import sys
import re

def format_litmus_file(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()

    if not lines:
        return

    # Point 1: Capitalize the first word of the file (e.g., "Vulkan" -> "VULKAN")
    first_line_parts = lines[0].strip().split(' ', 1)
    if len(first_line_parts) > 1:
        lines[0] = f"{first_line_parts[0].upper()} {first_line_parts[1]}\n"
    elif len(first_line_parts) == 1:
        lines[0] = f"{first_line_parts[0].upper()}\n"

    grid_start = -1
    grid_end = -1

    # Step 1: Identify the thread grid boundaries (Handles single-thread and multi-thread)
    for i, line in enumerate(lines):
        stripped = line.strip()

        # The grid header starts with P0 (e.g., "P0@sg..." or "P0 | P1")
        if grid_start == -1 and re.match(r'^P0(@|\s|$|\|)', stripped):
            grid_start = i

        # The grid ends right before any assertion/filter keywords
        if grid_start != -1 and re.match(r'^(~?exists|forall|filter)\b', stripped):
            grid_end = i - 1
            break

    # If no assertion block is found, grid goes to the end of the file
    if grid_start != -1 and grid_end == -1:
        grid_end = len(lines) - 1

    # Shrink grid_end if there are trailing blank lines
    while grid_end >= grid_start and lines[grid_end].strip() == "":
        grid_end -= 1

    # If no grid is found, leave the file untouched
    if grid_start == -1 or grid_end == -1:
        return

    # Step 2: Parse the grid and normalize comma spacing
    grid_lines = lines[grid_start:grid_end + 1]
    parsed_rows = []

    for row in grid_lines:
        cells = row.split('|')
        parsed_cells = []
        for cell in cells:
            clean_cell = cell.strip()
            # Fix comma spacing
            clean_cell = re.sub(r',\s*', ', ', clean_cell).strip()
            parsed_cells.append(clean_cell)
        parsed_rows.append(parsed_cells)

    # Step 3: Identify threads and map registers sequentially starting at r0
    header_cells = parsed_rows[0]
    threads = []

    # Extract thread numbers from the header (e.g., P0, P1, P2)
    for i, cell in enumerate(header_cells):
        m = re.search(r'P(\d+)', cell)
        if m:
            threads.append(m.group(1))
        else:
            threads.append(str(i))

    thread_regs = {t: set() for t in threads}

    # Collect registers from the grid bodies
    for row in parsed_rows[1:]:
        for i, cell in enumerate(row):
            if i < len(threads):
                t = threads[i]
                regs = re.findall(r'\b(r\d+)\b', cell)
                for r in regs:
                    thread_regs[t].add(r)

    # Collect registers from preamble (initial values) and post-grid (assertions)
    preamble_lines = lines[:grid_start]
    post_grid_lines = lines[grid_end + 1:]

    for line in preamble_lines + post_grid_lines:
        matches = re.findall(r'\bP(\d+)\s*:\s*(r\d+)\b', line)
        for t, r in matches:
            if t not in thread_regs:
                thread_regs[t] = set()
            thread_regs[t].add(r)

    # Build the dictionary mapping for each thread
    mapping = {}
    for t, regs in thread_regs.items():
        sorted_regs = sorted(list(regs), key=lambda x: int(x[1:]))
        mapping[t] = {old_r: f"r{idx}" for idx, old_r in enumerate(sorted_regs)}

    # Apply mapping strictly to the grid
    for r_idx in range(1, len(parsed_rows)):
        for c_idx in range(len(parsed_rows[r_idx])):
            if c_idx < len(threads):
                t = threads[c_idx]
                cell = parsed_rows[r_idx][c_idx]

                def repl_grid(match):
                    reg = match.group(1)
                    return mapping[t].get(reg, reg)

                parsed_rows[r_idx][c_idx] = re.sub(r'\b(r\d+)\b', repl_grid, cell)

    # Step 4: Calculate max lengths for formatting
    num_cols = max(len(row) for row in parsed_rows)
    max_lens = [0] * num_cols

    for row in parsed_rows:
        for i, cell in enumerate(row):
            clean_cell = cell[:-1].strip() if cell.endswith(';') else cell
            max_lens[i] = max(max_lens[i], len(clean_cell))

    # Step 5: Reformat the grid with exact spacing
    formatted_grid = []
    for row in parsed_rows:
        formatted_cells = []
        for i, cell in enumerate(row):
            is_last_col = (i == len(row) - 1)

            clean_cell = cell[:-1].strip() if cell.endswith(';') else cell
            padded_cell = clean_cell.ljust(max_lens[i])

            if is_last_col:
                formatted_cells.append(f" {padded_cell} ;")
            else:
                formatted_cells.append(f" {padded_cell} ")

        formatted_grid.append("|".join(formatted_cells) + "\n")

    # Step 6: Apply mapping to non-grid text, format initialization block, and split assertions
    def replace_pre_post(line):
        def repl(match):
            t = match.group(1)
            reg = match.group(2)
            new_reg = mapping.get(t, {}).get(reg, reg)
            return f"P{t}:{new_reg}"
        return re.sub(r'\bP(\d+)\s*:\s*(r\d+)\b', repl, line)

    new_lines = []

    # Process preamble
    while preamble_lines and preamble_lines[-1].strip() == "":
        preamble_lines.pop()

    in_init_block = False
    for line in preamble_lines:
        stripped = line.strip()
        if stripped == '{':
            in_init_block = True
            new_lines.append(replace_pre_post(line))
            continue
        elif stripped == '}':
            in_init_block = False
            new_lines.append(replace_pre_post(line))
            continue

        if in_init_block and stripped:
            if not stripped.endswith(';'):
                stripped += ';'

            if '=' in stripped:
                # Remove spaces around '=' to keep variables and registers consistent
                parts = stripped.split('=', 1)
                stripped = f"{parts[0].strip()}={parts[1].strip()}"

                # Ensure no spaces around the colon for registers (e.g., P0 : r0 -> P0:r0)
                stripped = re.sub(r'P(\d+)\s*:\s*(r\d+)', r'P\1:\2', stripped)

            new_lines.append(replace_pre_post(stripped + "\n"))
        else:
            new_lines.append(replace_pre_post(line))

    # Add newly mapped and formatted grid
    new_lines.extend(formatted_grid)

    # Insert a blank line after the thread grid
    new_lines.append("\n")

    # Process assertions/filters, skipping empty lines and merging single-line formulas
    cleaned_post = [line.strip() for line in post_grid_lines if line.strip() != ""]

    i = 0
    while i < len(cleaned_post):
        line = cleaned_post[i]

        # If the line is EXACTLY a keyword, look at the next line to combine them
        kw_match = re.match(r'^(~?exists|forall|filter)$', line)
        if kw_match and i + 1 < len(cleaned_post):
            next_line = cleaned_post[i+1]
            # Ensure the next line isn't another keyword block
            if not re.match(r'^(~?exists|forall|filter)', next_line):
                line = f"{line} {next_line}"
                i += 1 # Skip the next line since we just merged it

        new_lines.append(replace_pre_post(line + "\n"))
        i += 1

    # Guarantee file ends with a single newline character
    if new_lines and not new_lines[-1].endswith("\n"):
        new_lines[-1] += "\n"

    # Write back to file
    with open(filepath, 'w') as f:
        f.writelines(new_lines)

def main():
    if len(sys.argv) < 2:
        print("Usage: python format_litmus.py <directory_path>")
        sys.exit(1)

    directory = sys.argv[1]

    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory.")
        sys.exit(1)

    processed_count = 0
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".litmus"):
                filepath = os.path.join(root, file)
                format_litmus_file(filepath)
                processed_count += 1

    print(f"Successfully processed {processed_count} litmus test files.")

if __name__ == "__main__":
    main()
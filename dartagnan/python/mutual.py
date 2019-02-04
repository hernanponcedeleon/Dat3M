import os, sys, csv, getopt, subprocess, time
from math import log

help = """
help:
    -h, --help      show help
    
usage (with test execution):
    python3 python/plot.py -p litmus/C -c cat/linux-kernel.cat -t sc -b litmus/herd-not-supported.txt -s 30
    python3 python/plot.py --path litmus/C --cat cat/linux-kernel.cat --target sc --blacklist litmus/herd-not-supported.txt --timeout 30

usage (with data import from csv):
    python3 python/plot.py -p data.csv -s 30
    python3 python/plot.py --path data.csv --timeout 30
    
required (always):
    -p, --path      <path/to/tests>
    
required (test execution mode):
    -c, --cat       <path/to/model.cat>
    -t, --target    {sc|tso|arm|power} dartagnan target
    -s, --timeout   timeout in seconds (in import mode, defines axis size)
       
optional:
    -m, --mode      {log|idl|relax} dartagnan mode (default relax)
    -g, --out-graph <path/to/graph.png> file with generated graph (default out.png)
    -d, --out-data  <path/to/data.csv> file with generated execution time (default out.csv)
    -b, --blacklist <path/to/list.txt> list of files which should be excluded (default none)
    -w, --whitelist <path/to/list.txt> list of files which should be executed (default all), overwrites blacklist
    -f, --featured  <path/to/list.txt> list of files which should have different bullets on the plot
    -i, --herd-file <path/to/file.csv> file with earlier generated herd execution time (herd will not be executed)
    -v, --verbose   prints execution time (default false)
"""

class Env:
    def __init__(self):
        self.env = os.environ.copy()
        self.env["CLASSPATH"] = "./import/antlr-4.7-complete.jar:./import/com.microsoft.z3.jar:./import/commons-cli-1.4.jar:./import/commons-io-2.5.jar:./import/guava-23.0.jar:./bin"

    def execute(self, args, timeout):
        start = time.time()
        subprocess.call(args, env=self.env, stdout=subprocess.DEVNULL, timeout=timeout)
        end = time.time()
        return end - start

#class Group:
#    def __init__(self, name, bullet, size, color, alpha):
#        self.name = name
#        self.bullet = bullet
#        self.size = size
#        self.color = color
#        self.alpha = alpha
#        self.x = []
#        self.y = []

#    def add_item(self, x, y):
#        self.x.append(x)
#        self.y.append(y)

class Test:
    def __init__(self, path, cat, target, timeout, mode, graph_file, data_file, herd_file, blacklist, whitelist, featured, verbose):
        self.java_library_path = "./import"
        self.norm_log_base = 10

        self.plot_padding = 0.1
        self.timeout_line_width = 0.5
        self.timeout_color = "r"

        self.path = path
        self.cat = cat
        self.target = target
        self.timeout = timeout
        self.mode = mode
        self.verbose = verbose
        self.graph_file = graph_file
        self.data_file = data_file
        self.prepare_data_file()

        self.blacklist = []
        if blacklist is not None:
            self.blacklist = self.build_list(blacklist)

        self.whitelist = []
        if whitelist is not None:
            self.whitelist = self.build_list(whitelist)

        self.featured = []
        if featured is not None:
            self.featured = self.build_list(featured)

        self.herd_data = {}
        if herd_file is not None:
            self.load_herd_data(herd_file)

        self.env = Env()
        self.data = []

    def build_list(self, path):
        list = []
        if path is not None:
            with open(path) as file:
                list = file.readlines()
            list = [x.strip() for x in list]
        return list

    def load_herd_data(self, path):
        reader = csv.DictReader(open(path, "r"))
        self.herd_data = { rows["file"] : float(rows["herd_time"]) for rows in reader }

    def build_herd_args(self):
        args = ["cbmc"]
        if self.cat == "cat/tso.cat":
            args += ["-mm tso"]
        return args

    def build_dart_args(self):
        java_args = ['java']
        if self.java_library_path is not None:
            java_args += ["-Djava.library.path=" + self.java_library_path]
        dart_args = ["dartagnan/Dartagnan", "-t", self.target, "-cat", self.cat]
        if self.mode is not None and self.mode != "log":
            dart_args += ["-" + self.mode]
        return java_args + dart_args

    def extract_files(self):
        return subprocess.check_output(["find", self.path, "-name", "*.pts"]).decode().strip().split("\n")

    def should_run(self, file):
        if file in self.whitelist:
            return True
        if file in self.blacklist:
            return False
        return True

    def prepare_data_file(self):
        f = open(self.data_file, "w+")
        f.write("file,herd_time,dart_time\n")
        f.close()

    def handle_result(self, file, herd_time, dart_time):
        f = open(self.data_file, "a+")
        f.write("{},{:5.3f},{:5.3f}\n".format(file, herd_time, dart_time))
        f.close()
        if self.verbose:
            print("{:50s} {:5.3f}  {:5.3f}".format(file, herd_time, dart_time))

    def run_tests(self):
        herd_args_base = self.build_herd_args()
        dart_args_base = self.build_dart_args()
        for file in self.extract_files():
            if self.should_run(file):
                try:
                    if file in self.herd_data:
                        h = self.herd_data[file]
                    else:
                        h = self.env.execute(herd_args_base + [file], self.timeout)
                except subprocess.TimeoutExpired:
                    h = self.timeout
                try:
                    d = self.env.execute(dart_args_base + ["-i", file], self.timeout)
                except subprocess.TimeoutExpired:
                    d = self.timeout
                self.data.append([file, h, d])
                self.handle_result(file, h, d)

    def import_data(self):
        f = open(self.path, "r")
        reader = csv.reader(f, delimiter=',')
        next(reader, None)
        for row in reader:
            try:
                herd, dart = float(row[1]), float(row[2])
                if self.timeout is not None:
                    herd, dart = min(herd, self.timeout), min(dart, self.timeout)
                self.data.append([row[0], herd, dart])
            except ValueError:
                print("Invalid record: ", row)

    def run(self):
        if os.path.isdir(self.path):
            self.run_tests()
        else:
            self.import_data()
            if self.timeout is None:
                self.timeout = self.max_running_time()
        self.plot()

    def max_running_time(self):
        m = 0
        for item in self.data:
            m = max(m, item[1], item[2])
        return m

#    def normalise(self, v):
#        return log(v * 1000, self.norm_log_base)

#    def get_group(self, file):
#        if file in self.featured:
#            return self.groups.get("featured")
#        return self.groups.get("default")

#    def get_tick_labels(self, normalised_timeout):
#        base_labels = ["10 ms", "100 ms", "1 s", "10 s", "1 min", "10 min", "1 h"]
#        base_ticks = [0.01, 0.1, 1, 10, 60, 600, 3600]
#        ticks = [self.normalise(x) for x in base_ticks if self.normalise(x) < normalised_timeout]
#        return ticks, base_labels

    def get_timeout_label(self):
        if self.timeout >= 3600 and self.timeout % 3600 == 0:
            return "{:.0f} hours".format(self.timeout / 3600)
        if self.timeout >= 60 and self.timeout % 60 == 0:
            return "{:.0f} min".format(self.timeout / 60)
        return "{:.0f} sec".format(self.timeout)

#    def plot_timeout(self, norm_timeout):
#        timeout_label = self.get_timeout_label()
#        plt.plot([norm_timeout, norm_timeout], [0, norm_timeout],
#                 linewidth = self.timeout_line_width, color = self.timeout_color)
#        plt.text(norm_timeout, -0.2, timeout_label, horizontalalignment='center', verticalalignment='top',
#                 rotation = 'vertical', color = self.timeout_color, fontproperties = self.font)
#        plt.plot([0, norm_timeout], [norm_timeout, norm_timeout],
#                 linewidth = self.timeout_line_width, color = self.timeout_color)
#        plt.text(-0.2, norm_timeout, timeout_label, horizontalalignment='right', verticalalignment='center',
#                 color = self.timeout_color, fontproperties = self.font)

#    def plot(self):
#        plt.axes().set_aspect('equal')
#        for item in self.data:
#            self.get_group(item[0]).add_item(self.normalise(item[1]), self.normalise(item[2]))

#        norm_timeout = self.normalise(self.timeout)
#        ax_size = norm_timeout * (1 + self.plot_padding)
#        plt.axis([0, ax_size, 0, ax_size])

#        for group in self.groups.values():
#            plt.scatter(group.x, group.y, s = group.size, c = group.color, alpha = group.alpha,
#                        marker = group.bullet, label = group.name)

#        plt.xlabel("herd", fontproperties = self.font)
#        plt.ylabel("dartagnan", fontproperties = self.font)

#        ticks, labels = self.get_tick_labels(norm_timeout)
#        plt.xticks(ticks, labels, rotation = 'vertical', horizontalalignment='center', fontproperties = self.font)
#        plt.yticks(ticks, labels, fontproperties = self.font)

#        self.plot_timeout(norm_timeout)

#        plt.legend(prop = self.legend_font)

#        plt.grid()
#        plt.savefig(self.graph_file, dpi = 200, bbox_inches = 'tight', pad_inches = 0)

def main(argv):
    try:
        opts, args = getopt.getopt(argv, "hp:c:t:s:m:g:d:b:w:f:i:v",
                                   ["help=", "path=", "cat=", "target=", "timeout=", "mode=", "out-graph=", "out-data=",
                                    "blacklist=", "whitelist=", "featured=", "herd-file=", "verbose="])
    except getopt.GetoptError:
        print(help)
        sys.exit(2)

    path, cat, target, timeout, blacklist, whitelist, featured = None, None, None, None, None, None, None
    mode, herd_file, verbose, graph_file, data_file = "relaxed", None, False, "out.png", "out.csv"

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print(help)
            sys.exit()
        elif opt in ("-p", "--path"):
            path = arg
        elif opt in ("-c", "--cat"):
            cat = arg
        elif opt in ("-t", "--target"):
            target = arg if arg in ["sc", "tso", "arm", "power"] else None
        elif opt in ("-s", "--timeout"):
            timeout = int(arg)
        elif opt in ("-m", "--mode"):
            mode = arg if arg in ["kleene", "idl", "relaxed"] else "relaxed"
        elif opt in ("-g", "--out-graph"):
            graph_file = arg
        elif opt in ("-d", "--out-data"):
            data_file = arg
        elif opt in ("-b", "--blacklist"):
            blacklist = arg
        elif opt in ("-w", "--whitelist"):
            whitelist = arg
        elif opt in ("-f", "--featured"):
            featured = arg
        elif opt in ("-i", "--herd-file"):
            herd_file = arg
        elif opt in ("-v", "--verbose"):
            verbose = True

    if path is None:
        print(help)
        sys.exit(2)

    if os.path.isfile(path) or (os.path.isdir(path) and all([cat, target, timeout])):
        Test(path = path, cat = cat, target = target, mode = mode, timeout = timeout,graph_file = graph_file,
             data_file = data_file, blacklist = blacklist, whitelist = whitelist, featured = featured,
             herd_file = herd_file, verbose = verbose).run()
    else:
        print("Invalid path")


if __name__ == "__main__":
    main(sys.argv[1:])

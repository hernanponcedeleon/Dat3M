# Import the necessary modules
import matplotlib.pyplot as plt
import pandas as pd
from PIL import Image

path = '/Users/ponce/git/Dat3M/output/csv/'

methods = ["assume", "refinement"]
arch = ["TSO", "Power", "ARM8"]

genmc = pd.read_csv(path + 'genMCTest-genMC.csv')
genmc_df = pd.DataFrame(genmc)

df = df_empty = pd.DataFrame({'benchmark' : []})
df['benchmark'] = genmc.iloc[:, 0].apply(lambda x: x.replace(".c", ""))
df['GenMC'] = genmc.iloc[:, 1]

mapping = dict([
    ('assume', 'Dartagnan'),
    ('refinement', 'Refinement')
])

for a in arch:
    for m in methods:
        current_df = pd.DataFrame(pd.read_csv(path + "CLocksTest-" + m + "-" + a + ".csv"))
        df[mapping[m]] = current_df.iloc[:, 1]

    df.set_index('benchmark').sort_index().plot.bar(log=True, width=0.8)
    plt.title(a)
    plt.xticks(rotation=45, ha="right")
    plt.xlabel("")
    plt.ylabel("Time (ms)")
    plt.tight_layout()
    plt.legend(loc='upper left', bbox_to_anchor=(0.01, 1.025))
    plt.savefig("Figures/" + a + ".png")

arch = ["TSO", "Power", "ARM8", "Linux"]

mapping_files = dict([
    ('two-TSO', pd.read_csv(path + 'DartagnanX86Test-two.csv')),
    ('refinement-TSO', pd.read_csv(path + 'DartagnanX86Test-refinement.csv')),
    ('two-Power', pd.read_csv(path + 'DartagnanPPCTest-two.csv')),
    ('refinement-Power', pd.read_csv(path + 'DartagnanPPCTest-refinement.csv')),
    ('two-ARM8', pd.read_csv(path + 'DartagnanAARCH64Test-two.csv')),
    ('refinement-ARM8', pd.read_csv(path + 'DartagnanAARCH64Test-refinement.csv')),
    ('two-Linux', pd.read_csv(path + 'DartagnanLinuxTest-two.csv')),
    ('refinement-Linux', pd.read_csv(path + 'DartagnanLinuxTest-refinement.csv'))
])

mapping_title = dict([
    ('TSO', 'X86'),
    ('Power', 'PPC'),
    ('ARM8', 'AARCH64'),
    ('Linux', 'LKMM')
])

for a in arch:
    plt.figure()
    f, ax = plt.subplots(figsize=(6, 6))
    ax.plot([0, 1], [0, 1], color='r', transform=ax.transAxes)
    plt.title(mapping_title[a])
    plt.xlabel("Dartagnan time (ms)")
    limit = 1000
    if a == "TSO":
        limit = 60
    if a == "Power":
        limit = 120
    if a == "ARM8":
        limit = 90
    if a == "Linux":
        limit = 1000
    plt.xlim([0, limit])
    plt.ylim([0, limit])
    plt.ylabel("Refinement time (ms)")
    plt.plot(
        mapping_files["two-" + a].iloc[:, 1],
        mapping_files["refinement-" + a].iloc[:, 1],
        's')
    plt.savefig("Figures/litmus-" + a + ".png")
    plt.close()

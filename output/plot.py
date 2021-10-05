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
df['genmc'] = genmc.iloc[:, 1]

for a in arch:
    for m in methods:
        current_df = pd.DataFrame(pd.read_csv(path + "CLocksTest-" + m + "-" + a + ".csv"))
        df[m] = current_df.iloc[:, 1]

    df.set_index('benchmark').sort_index().plot.bar(log=True, width=0.8)
    plt.title(a)
    plt.xticks(rotation=45, ha="right")
    plt.xlabel("")
    plt.ylabel("Time (ms)")
    plt.tight_layout()
    plt.legend(loc='upper left', bbox_to_anchor=(0.01, 1.025))
    plt.savefig(a + ".png")
    Image.open(a + ".png").show()

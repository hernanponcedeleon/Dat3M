# Import the necessary modules
import matplotlib.pyplot as plt
import pandas as pd
from PIL import Image
import os.path

outputPath = os.getenv('DAT3M_OUTPUT')
csvPath = outputPath + '/csv/'
figurePath = outputPath + '/Figures/'
if not os.path.exists(figurePath):
    os.makedirs(figurePath)

mapping_method = dict([
    ('assume', 'Dartagnan'),
    ('two', 'Dartagnan'),
    ('caat', 'CAAT'),
    ('herd', 'Herd'),
])

mapping_title = dict([
    ('TSO', 'TSO'),
    ('Power', 'Power'),
    ('ARM8', 'ARMv8'),
    ('RISCV', 'RISC-V'),
    ('Linux', 'LKMM'),
    ('C11', 'RC11'),
    ('IMM', 'IMM')
])

mapping_files = dict([
    ('two-TSO', csvPath + 'LitmusX86-two-solvers.csv'),
    ('caat-TSO', csvPath + 'LitmusX86-caat.csv'),
    ('herd-TSO', csvPath + 'HerdX86-.csv'),
    ('two-Power', csvPath + 'LitmusPPC-two-solvers.csv'),
    ('caat-Power', csvPath + 'LitmusPPC-caat.csv'),
    ('herd-Power', csvPath + 'HerdPPC-.csv'),
    ('two-ARM8', csvPath + 'LitmusAARCH64-two-solvers.csv'),
    ('caat-ARM8', csvPath + 'LitmusAARCH64-caat.csv'),
    ('herd-ARM8', csvPath + 'HerdAARCH64-.csv'),
    ('two-RISCV', csvPath + 'LitmusRISCV-two-solvers.csv'),
    ('caat-RISCV', csvPath + 'LitmusRISCV-caat.csv'),
    ('herd-RISCV', csvPath + 'HerdRISCV-.csv'),
    ('two-Linux', csvPath + 'LitmusLinux-two-solvers.csv'),
    ('caat-Linux', csvPath + 'LitmusLinux-caat.csv'),
    ('herd-Linux', csvPath + 'HerdLinux-.csv')
])

## Create empty csv files for non existent ones
for key in mapping_files.keys():
    if not os.path.exists(mapping_files[key]):
        f = open(mapping_files[key], 'w+')
        f.write('benchmark, result, time\n')
        f.write('dummy, UNKNOWN, 1\n')
        f.close()

cFiles = [csvPath + 'TSO-assume.csv',
          csvPath + 'TSO-caat.csv',
          csvPath + 'TSO-cutting.csv',
          csvPath + 'TSO-nidhugg.csv',
          csvPath + 'Power-assume.csv',
          csvPath + 'Power-caat.csv',
          csvPath + 'Power-cutting.csv',
          csvPath + 'ARM8-assume.csv',
          csvPath + 'ARM8-caat.csv',
          csvPath + 'ARM8-cutting.csv',
          csvPath + 'RISCV-assume.csv',
          csvPath + 'RISCV-caat.csv',
          csvPath + 'IMM-assume.csv',
          csvPath + 'IMM-caat.csv',
          csvPath + 'IMM-cutting.csv',
          csvPath + 'IMM-genmc.csv',
          csvPath + 'C11-assume.csv',
          csvPath + 'C11-caat.csv',
          csvPath + 'C11-cutting.csv',
          csvPath + 'C11-genmc.csv',
        ]

## Create empty csv files for non existent ones
for file in cFiles:
    if not os.path.exists(file):
        f = open(file, 'w+')
        f.write('benchmark, result, time\n')
        f.write('dummy, UNKNOWN, 1\n')
        f.close()

###################################################
#### Generates bar char for the lock benchmarks ###
###################################################

arch = ['TSO', 'Power', 'ARM8', 'RISCV', 'IMM', 'C11']

genmcIMM = pd.read_csv(csvPath + 'IMM-genmc.csv')
genmcRC11 = pd.read_csv(csvPath + 'C11-genmc.csv')
nidhugg = pd.read_csv(csvPath + 'TSO-nidhugg.csv')

lncol = 3
my_colors = ['tab:blue', 'tab:cyan', 'orange']

for a in arch:
    df = df_empty = pd.DataFrame({'benchmark' : []})

    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-caat.csv'))
    ## colums are: benchmark, result, time
    df[mapping_method['caat']] = current_df.iloc[:, 2]
    df['benchmark'] = current_df.iloc[:, 0].apply(lambda x: x.replace(".bpl", ""))

    if a != 'RISCV':
        current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-cutting.csv'))
        ## colums are: benchmark, result, time
        df['Cutting'] = current_df.iloc[:, 2]
    else:
        lncol = 2
        my_colors = ['tab:blue', 'orange']
        
    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-assume.csv'))
    ## colums are: benchmark, result, time
    df[mapping_method['assume']] = current_df.iloc[:, 2]

    if a == 'IMM':
        ## colums are: benchmark, result, time
        df['GenMC'] = genmcIMM.iloc[:, 2]
        lncol = 4
        my_colors = ['tab:blue', 'tab:cyan', 'orange', 'tab:green']
        
    if a == 'C11':
        ## colums are: benchmark, result, time
        df['GenMC'] = genmcRC11.iloc[:, 2]
        lncol = 4
        my_colors = ['tab:blue', 'tab:cyan', 'orange', 'tab:green']
        
    if a == 'TSO':
        ## colums are: benchmark, result, time
        df['Nidhugg'] = nidhugg.iloc[:, 2]
        lncol = 4
        my_colors = ['tab:blue', 'tab:cyan', 'orange', 'tab:red']
        
    df.loc["Total"] = df.loc[:, df.columns != 'benchmark'].mean()
    df[['benchmark']] = df[['benchmark']].fillna('$\overline{\mathcal{X}}$')

    plt.figure()
    df.set_index('benchmark').plot.bar(log=True, width=0.8, color=my_colors)
    plt.title(mapping_title[a])
    for i in range(len(df.columns)):
        bars = plt.gca().containers[i-1]
        hatches = ["//////" if x == 12 else '' for x in range(len(df.index))]
        for bar, hatch, label in zip(bars, hatches, df.index):
            bar.set_hatch(hatch)
    plt.xticks(rotation=45, ha='right')
    plt.xlabel('')
    plt.ylabel('Time (ms)')
    plt.tight_layout()
    plt.legend(loc='upper center', ncol=lncol)
    plt.ylim(1, 10000000)
    plt.axhline(y=1000000, color='grey', linestyle='--')
    plt.savefig(figurePath + mapping_title[a] + '.png')
    plt.close()

###########################################
### Generates plot for the litmus tests ###
###########################################

arch = ['TSO', 'Power', 'ARM8', 'RISCV', 'Linux']

total = df_empty = pd.DataFrame({mapping_method['caat'] : []})

for a in arch:
    df = df_empty = pd.DataFrame({'benchmark' : []})
    df['benchmark'] = pd.read_csv(mapping_files['two-' + a]).iloc[:, 0].apply(lambda x: os.path.basename(x))
    df['two'] = pd.read_csv(mapping_files['two-' + a]).iloc[:, 2]
    df['caat'] = pd.read_csv(mapping_files['caat-' + a]).iloc[:, 2]
    df['herd'] = pd.read_csv(mapping_files['herd-' + a]).iloc[:, 2]

    total.loc[mapping_title[a] + '\n (' + str(len(df.index)) + ')', mapping_method['two']] = df['two'].sum()
    total.loc[mapping_title[a] + '\n (' + str(len(df.index)) + ')', mapping_method['caat']] = df['caat'].sum()
    total.loc[mapping_title[a] + '\n (' + str(len(df.index)) + ')', mapping_method['herd']] = df['herd'].sum()
        
#########################
### Accumulated times ###
#########################

plt.figure()
total.plot.bar(log=True, width=0.8, color=['tab:blue', 'orange', 'tab:purple'])
plt.title('Litmus Tests')
plt.xticks(rotation=0, ha='center')
plt.xlabel('')
plt.ylabel('Time (ms)')
plt.tight_layout()
plt.legend(loc='upper center', ncol=3)
plt.ylim(1, 10000000)
plt.savefig(figurePath + 'litmus.png')
plt.close()


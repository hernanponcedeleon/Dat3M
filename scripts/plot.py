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
    ('refinement', 'CAAT'),
    ('herd', 'Herd'),
])

mapping_title = dict([
    ('TSO', 'TSO'),
    ('Power', 'Power'),
    ('ARM8', 'ARM8'),
    ('Linux', 'LKMM'),
    ('IMM', 'IMM'),
    ('RC11', 'RC11')
])

mapping_files = dict([
    ('two-TSO', csvPath + 'LitmusX86-two-solvers.csv'),
    ('refinement-TSO', csvPath + 'LitmusX86-refinement.csv'),
    ('herd-TSO', csvPath + 'HerdX86-.csv'),
    ('two-Power', csvPath + 'LitmusPPC-two-solvers.csv'),
    ('refinement-Power', csvPath + 'LitmusPPC-refinement.csv'),
    ('herd-Power', csvPath + 'HerdPPC-.csv'),
    ('two-ARM8', csvPath + 'LitmusAARCH64-two-solvers.csv'),
    ('refinement-ARM8', csvPath + 'LitmusAARCH64-refinement.csv'),
    ('herd-ARM8', csvPath + 'HerdAARCH64-.csv'),
    ('two-Linux', csvPath + 'LitmusLinux-two-solvers.csv'),
    ('refinement-Linux', csvPath + 'LitmusLinux-refinement.csv'),
    ('herd-Linux', csvPath + 'HerdLinux-.csv')
])

## Create empty csv files for non existent ones
for key in mapping_files.keys():
    if not os.path.exists(mapping_files[key]):
        f = open(mapping_files[key], 'w+')
        f.write('benchmark, result, time\n')
        f.write('dummy, UNKNOWN, 1\n')
        f.close()

cFiles = [csvPath + 'GenmcIMM-.csv',
          csvPath + 'GenmcRC11-.csv',
          csvPath + 'Nidhugg-.csv',
          csvPath + 'DartagnanTSO-assume.csv',
          csvPath + 'DartagnanTSO-refinement.csv',
          csvPath + 'DartagnanPower-assume.csv',
          csvPath + 'DartagnanPower-refinement.csv',
          csvPath + 'DartagnanARM8-assume.csv',
          csvPath + 'DartagnanARM8-refinement.csv',
          csvPath + 'DartagnanIMM-assume.csv',
          csvPath + 'DartagnanIMM-refinement.csv',
          csvPath + 'DartagnanRC11-assume.csv',
          csvPath + 'DartagnanRC11-refinement.csv',
          csvPath + 'CuttingTSO-refinement.csv',
          csvPath + 'CuttingPower-refinement.csv',
          csvPath + 'CuttingARM8-refinement.csv',
          csvPath + 'CuttingIMM-refinement.csv',
          csvPath + 'CuttingRC11-refinement.csv'
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

methods = ['refinement','assume']
arch = ['TSO', 'Power', 'ARM8', 'IMM', 'RC11']

genmcIMM = pd.read_csv(csvPath + 'GenmcIMM-.csv')
genmcRC11 = pd.read_csv(csvPath + 'GenmcRC11-.csv')
nidhugg = pd.read_csv(csvPath + 'Nidhugg-.csv')

lncol = 3
my_colors = ['tab:blue', 'tab:cyan', 'orange']

for a in arch:
    df = df_empty = pd.DataFrame({'benchmark' : []})
    df['benchmark'] = genmcIMM.iloc[:, 0].apply(lambda x: x.replace(".c", ""))

    current_df = pd.DataFrame(pd.read_csv(csvPath + 'Dartagnan' + a + '-refinement.csv'))
    ## colums are: benchmark, result, time
    df[mapping_method['refinement']] = current_df.iloc[:, 2]

    current_df = pd.DataFrame(pd.read_csv(csvPath + 'Cutting' + a + '-refinement.csv'))
    ## colums are: benchmark, result, time
    df['Cutting'] = current_df.iloc[:, 2]

    current_df = pd.DataFrame(pd.read_csv(csvPath + 'Dartagnan' + a + '-assume.csv'))
    ## colums are: benchmark, result, time
    df[mapping_method['assume']] = current_df.iloc[:, 2]

    if a == 'IMM':
        ## colums are: benchmark, result, time
        df['GenMC'] = genmcIMM.iloc[:, 2]
        lncol = 4
        my_colors = ['tab:blue', 'tab:cyan', 'orange', 'tab:green']

    if a == 'RC11':
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
    df[['benchmark']] = df[['benchmark']].fillna('average')

    plt.figure()
    df.set_index('benchmark').plot.bar(log=True, width=0.8, color=my_colors)
    plt.title(mapping_title[a])
    plt.xticks(rotation=45, ha='right')
    plt.xlabel('')
    plt.ylabel('Time (ms)')
    plt.tight_layout()
    plt.legend(loc='upper center', ncol=lncol)
    plt.ylim(1, 10000000)
    plt.axhline(y=1000000, color='grey', linestyle='--')
    plt.savefig(figurePath + a + '.png')
    plt.close()

###########################################
### Generates plot for the litmus tests ###
###########################################

arch = ['TSO', 'Power', 'ARM8', 'Linux']

total = df_empty = pd.DataFrame({mapping_method['refinement'] : []})

for a in arch:
    df = df_empty = pd.DataFrame({'benchmark' : []})
    df['benchmark'] = pd.read_csv(mapping_files['two-' + a]).iloc[:, 0].apply(lambda x: os.path.basename(x))
    df['two'] = pd.read_csv(mapping_files['two-' + a]).iloc[:, 2]
    df['refinement'] = pd.read_csv(mapping_files['refinement-' + a]).iloc[:, 2]
    df['herd'] = pd.read_csv(mapping_files['herd-' + a]).iloc[:, 2]

    total.loc[a + '\n (' + str(len(df.index)) + ')', mapping_method['two']] = df['two'].sum()
    total.loc[a + '\n (' + str(len(df.index)) + ')', mapping_method['refinement']] = df['refinement'].sum()
    total.loc[a + '\n (' + str(len(df.index)) + ')', mapping_method['herd']] = df['herd'].sum()
        
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

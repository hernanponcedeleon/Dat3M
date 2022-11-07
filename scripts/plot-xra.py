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
    ('assume-xra', 'XRA'),
    ('assume-xra-acy', 'XRA + ACY'),
    ('assume-cav19', 'CAV19'),
    ('caat-xra', 'CAAT + XRA'),
    ('caat-xra-acy', 'CAAT + XRA + ACY'),
    ('caat-cav19', 'CAAT + CAV19'),
])

mapping_title = dict([
    ('TSO', 'TSO'),
    ('POWER', 'Power'),
    ('ARM8', 'ARMv8'),
    ('RISCV', 'RISC-V'),
])

cFiles = [
          csvPath + 'TSO-assume-cav19.csv',
          csvPath + 'TSO-assume-xra.csv',
          csvPath + 'TSO-assume-xra-acy.csv',
          csvPath + 'TSO-caat-cav19.csv',
          csvPath + 'TSO-caat-xra.csv',
         csvPath + 'ARM8-assume-cav19.csv',
          csvPath + 'ARM8-assume-xra.csv',
          csvPath + 'ARM8-assume-xra-acy.csv',
          csvPath + 'ARM8-caat-cav19.csv',
          csvPath + 'ARM8-caat-xra.csv',
          csvPath + 'POWER-assume-cav19.csv',
          csvPath + 'POWER-assume-xra.csv',
          csvPath + 'POWER-assume-xra-acy.csv',
          csvPath + 'POWER-caat-cav19.csv',
          csvPath + 'POWER-caat-xra.csv',
          csvPath + 'RISCV-assume-cav19.csv',
          csvPath + 'RISCV-assume-xra.csv',
          csvPath + 'RISCV-assume-xra-acy.csv',
          csvPath + 'RISCV-caat-cav19.csv',
          csvPath + 'RISCV-caat-xra.csv',
        ]

## Create empty csv files for non existent ones
for file in cFiles:
    if not os.path.exists(file):
        f = open(file, 'w+')
        f.write('benchmark, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time\n')
        f.write('dummy, -1, -1, -1, -1, -1, UNKNOWN, -1, -1, -1\n')
        f.close()

###################################################
#### Generates bar char for the lock benchmarks ###
###################################################

arch = ['TSO', 'POWER', 'ARM8', 'RISCV']

lncol = 4
my_colors = ['tab:blue', 'tab:cyan', 'orange', 'tab:green']

for a in arch:
    dfAssume = df_empty = pd.DataFrame({'benchmark' : []})
    dfCaat = df_empty = pd.DataFrame({'benchmark' : []})
    stats = df_empty = pd.DataFrame({'may-set' : [], 'must-set' : [], 'act-set' : [], 'smt-vars' : [], 'acyc-size' : [], 'veri-time' : []})

    ##############
    ### Assume ###
    ##############

    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-assume-cav19.csv'))
    ## colums are: benchmark, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time
    dfAssume['benchmark'] = current_df.iloc[:, 0].apply(lambda x: x.replace(".bpl", ""))
    dfAssume[mapping_method['assume-cav19']] = current_df.iloc[:, 9]

    stats.loc['\\textsc{' + mapping_method['assume-cav19'] + '}', 'may-set'] = str(current_df.iloc[:, 1].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-cav19'] + '}', 'must-set'] = str(current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-cav19'] + '}', 'act-set'] = str(current_df.iloc[:, 3].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-cav19'] + '}', 'smt-vars'] = str(current_df.iloc[:, 4].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-cav19'] + '}', 'acyc-size'] = str(current_df.iloc[:, 5].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-cav19'] + '}', 'veri-time'] = str(current_df.iloc[:, 9].sum()).split(".")[0]

    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-assume-xra.csv'))
    ## colums are: benchmark, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time
    dfAssume[mapping_method['assume-xra']] = current_df.iloc[:, 9]

    stats.loc['\\textsc{' + mapping_method['assume-xra'] + '}', 'may-set'] = str(current_df.iloc[:, 1].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra'] + '}', 'must-set'] = str(current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra'] + '}', 'act-set'] = str(current_df.iloc[:, 3].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra'] + '}', 'smt-vars'] = str(current_df.iloc[:, 4].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra'] + '}', 'acyc-size'] = str(current_df.iloc[:, 5].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra'] + '}', 'veri-time'] = str(current_df.iloc[:, 9].sum()).split(".")[0]

    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-assume-xra-acy.csv'))
    ## colums are: benchmark, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time
    dfAssume[mapping_method['assume-xra-acy']] = current_df.iloc[:, 9]

    stats.loc['\\textsc{' + mapping_method['assume-xra-acy'] + '}', 'may-set'] = str(current_df.iloc[:, 1].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra-acy'] + '}', 'must-set'] = str(current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra-acy'] + '}', 'act-set'] = str(current_df.iloc[:, 3].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra-acy'] + '}', 'smt-vars'] = str(current_df.iloc[:, 4].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra-acy'] + '}', 'acyc-size'] = str(current_df.iloc[:, 5].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['assume-xra-acy'] + '}', 'veri-time'] = str(current_df.iloc[:, 9].sum()).split(".")[0]

    dfAssume.loc["Total"] = dfAssume.loc[:, dfAssume.columns != 'benchmark'].mean()
    dfAssume[['benchmark']] = dfAssume[['benchmark']].fillna('$\overline{\mathcal{X}}$')

    ##############
    #### CAAT ####
    ##############

    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-caat-cav19.csv'))
    ## colums are: benchmark, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time
    dfCaat[mapping_method['caat-cav19']] = current_df.iloc[:, 9]
    dfCaat['benchmark'] = current_df.iloc[:, 0].apply(lambda x: x.replace(".bpl", ""))

    stats.loc['\\textsc{' + mapping_method['caat-cav19'] + '}', 'may-set'] = str(current_df.iloc[:, 1].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-cav19'] + '}', 'must-set'] = str(current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-cav19'] + '}', 'act-set'] = str(current_df.iloc[:, 1].sum() - current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-cav19'] + '}', 'smt-vars'] = str(current_df.iloc[:, 4].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-cav19'] + '}', 'acyc-size'] = str(current_df.iloc[:, 5].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-cav19'] + '}', 'veri-time'] = str(current_df.iloc[:, 9].sum()).split(".")[0]

    current_df = pd.DataFrame(pd.read_csv(csvPath + a + '-caat-xra.csv'))
    ## colums are: benchmark, may-size, must-size, act-size, smt-vars, acyc-size, result, ra_time, xra_time, veri_time
    dfCaat[mapping_method['caat-xra']] = current_df.iloc[:, 9]

    stats.loc['\\textsc{' + mapping_method['caat-xra'] + '}', 'may-set'] = str(current_df.iloc[:, 1].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-xra'] + '}', 'must-set'] = str(current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-xra'] + '}', 'act-set'] = str(current_df.iloc[:, 1].sum() - current_df.iloc[:, 2].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-xra'] + '}', 'smt-vars'] = str(current_df.iloc[:, 4].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-xra'] + '}', 'acyc-size'] = str(current_df.iloc[:, 5].sum()).split(".")[0]
    stats.loc['\\textsc{' + mapping_method['caat-xra'] + '}', 'veri-time'] = str(current_df.iloc[:, 9].sum()).split(".")[0]

    dfCaat.loc["Total"] = dfCaat.loc[:, dfCaat.columns != 'benchmark'].mean()
    dfCaat[['benchmark']] = dfCaat[['benchmark']].fillna('$\overline{\mathcal{X}}$')

    print(dfCaat)
    print()
    print(dfAssume)
    print()
    print(stats)

    ## Save stats
    stats.to_csv(os.environ['DAT3M_OUTPUT'] + '/csv/' + a + '-Stats.csv', index=True)

    ## Save caat figure
    plt.figure()
    dfCaat.set_index('benchmark').plot.bar(width=0.8, color=my_colors)
    plt.title(mapping_title[a])
    for i in range(len(dfCaat.columns)):
        bars = plt.gca().containers[i-1]
        hatches = ["//////" if x == 11 else '' for x in range(len(dfCaat.index))]
        for bar, hatch, label in zip(bars, hatches, dfCaat.index):
            bar.set_hatch(hatch)
    plt.xticks(rotation=45, ha='right')
    plt.xlabel('')
    plt.ylabel('Time (ms)')
    plt.yscale('log',base=2) 
    plt.tight_layout()
    plt.legend(loc='upper center', ncol=lncol)
    plt.ylim(256, 3000000)
    plt.axhline(y=900000, color='grey', linestyle='--')
    plt.savefig(figurePath + mapping_title[a] + '-caat.png')
    plt.close()

    ## Save assume figure
    plt.figure()
    dfAssume.set_index('benchmark').plot.bar(width=0.8, color=my_colors)
    plt.title(mapping_title[a])
    for i in range(len(dfAssume.columns)):
        bars = plt.gca().containers[i-1]
        hatches = ["//////" if x == 11 else '' for x in range(len(dfAssume.index))]
        for bar, hatch, label in zip(bars, hatches, dfAssume.index):
            bar.set_hatch(hatch)
    plt.xticks(rotation=45, ha='right')
    plt.xlabel('')
    plt.ylabel('Time (ms)')
    plt.yscale('log',base=2) 
    plt.tight_layout()
    plt.legend(loc='upper center', ncol=lncol)
    plt.ylim(256, 3000000)
    plt.axhline(y=900000, color='grey', linestyle='--')
    plt.savefig(figurePath + mapping_title[a] + '-assume.png')
    plt.close()

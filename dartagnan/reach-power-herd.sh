for file in ../../Projects/Memory-Models/LitmusSuite/safe/*.litmus;
do
    echo $file;
    herd7 -model ../../Projects/Memory-Models/herd/power.cat $file | grep -e 'Never' | wc -l;
done

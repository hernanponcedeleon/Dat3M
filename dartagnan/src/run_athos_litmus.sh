for file in ../../../Projects/Memory-Models/LitmusSuite/safe/*.litmus;
do
    echo $(basename $file);
    java athos/Athos -t $1 -i $file
done

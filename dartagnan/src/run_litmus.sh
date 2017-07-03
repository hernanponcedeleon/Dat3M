for file in ../../../Projects/Memory-Models/LitmusSuite/safe/*.litmus;
do
    echo $(basename $file);
    java porthos/Porthos -s $1 -t $2 -i $file
done

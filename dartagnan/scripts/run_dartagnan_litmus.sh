for file in ../../../Projects/Memory-Models/LitmusSuite/reach/*.litmus;
do
    echo $(basename $file);
    java dartagnan/Dartagnan -t $1 -i $file
done

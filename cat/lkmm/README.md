This folder contains different variants of the Linux Kernel Memory Model (LKMM).
The models have been slighlty modified (*) to be used with Dartagnan.

- lkmm-v00: official version up to version 6.2 of the kernel.
- lkmm-v01: updated via [this](https://lkml.org/lkml/2022/11/16/1555) patch.

(*) Dartagnan neither supports bell files (thus definitions like `Marked` and `Plain` were moved to the cat file) nor it allows to "update relations on the fly" (thus we use `update-fence` and `update-strong-fence`).
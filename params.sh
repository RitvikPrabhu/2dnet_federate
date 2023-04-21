
#!/bin/bash

#options: ver1/ver2
export enable_gr="false"
#to enable graph change pytorch version above otherwise the below two parameters wont be respected

export gr_mode="reduce-overhead"
export gr_back="aot-eager"

export enable_profile="false"
export profile_perct=0.2
#graph_mode: 1-> 2-> 3-> max-autotune



export batch_size=32
export epochs=50
export retrain=0
export num_data_w=4
export new_load="false"
export wandb=-1
export lr=0.001
export dr=0.95
export distback="gloo"
# options mag/l1_struc or random_unstru will be set otherwise
export prune_t="random_unstru"
export prune_amt=0.5
#options enable/disable
export mp="false"
export schedtype="expo"
#pytorch version 1 or version 2(with new graph support)

export inferonly="false"
echo "batch : $batch_size"
echo "retrain : $retrain"
echo "epochs : $epochs"

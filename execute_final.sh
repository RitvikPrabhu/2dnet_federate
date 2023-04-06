#!/bin/bash

if [ "$enable_profile" = "true" ];then
  if [ "$new_load" = "true" ]; then
    export file="sparse_ddnet_pro.py"
  else
    export file="sparse_ddnet_old_dl_profile.py"
  fi
else
    if [ "$new_load" = "true" ]; then
    export file="sparse_ddnet.py"
  else
    export file="sparse_ddnet_old_dl.py"
  fi
fi


export CMD="python ${file} --batch ${batch_size} --epochs ${epochs} --retrain ${retrain} --out_dir $SLURM_JOBID --amp ${mp} --num_w $num_data_w --prune_amt $prune_amt --prune_t $prune_t  --wan $wandb --lr ${lr} --dr ${dr} --distback ${distback}"


# change base container image to graph is supported in pytorch 2.0
if [ "$pytor" = "ver1" ]; then
  export imagefile=/home/ayushchatur/ondemand/dev/pytorch_22.04.sif
else
  export imagefile=/home/ayushchatur/ondemand/dev/pytorch2.sif
  export CMD="${CMD} --gr_mode $graph_mode --gr_backend $gr_back"
fi


#export profile_prefix="dlprof --output_path=${SLURM_JOBID} --profile_name=dlpro_${SLURM_NODEID}_rank${SLURM_PROCID} --mode=pytorch -f true --reports=all -y 60 -d 120 --nsys_base_name=nsys_${SLURM_NODEID}_rank${SLURM_PROCID}  --nsys_opts=\"-t osrt,cuda,nvtx,cudnn,cublas\" "

#export profile_prefix="nsys profile -t cuda,nvtx,cudnn,cublas --show-output=true --force-overwrite=true --delay=60 --duration=220 --export=sqlite -o ${SLURM_JOBID}/profile_rank${SLURM_PROCID}_node_${SLURM_NODEID}"


echo "procid: ${SLURM_PROCID}"
#echo "cmd: $CMD"
echo "final command: $BASE exec --nv --writable-tmpfs --bind=/projects/synergy_lab/garvit217,/cm/shared:/cm/shared,$TMPFS $imagefile $profile_prefix $CMD"


if [ "$enable_profile" = "true" ]; then

  export imagefile=/home/ayushchatur/ondemand/dev/pytorch_21.12.sif
  $BASE exec --nv --writable-tmpfs --bind=/projects/synergy_lab/garvit217,/cm/shared:/cm/shared,$TMPFS $imagefile dlprof --output_path=${SLURM_JOBID} --profile_name=dlpro_{SLURM_PROCID} --dump_model_data=true --mode=pytorch --nsys_opts="-t osrt,cuda,nvtx,cudnn,cublas --cuda-memory-usage=true --gpuctxsw=true " -f true --reports=all --delay 120 --duration 60 ${CMD}

elif [ "$inferonly" = "false" ]; then

  $BASE exec --nv --writable-tmpfs --bind=/projects/synergy_lab/garvit217,/cm/shared:/cm/shared,$TMPFS $imagefile $profile_prefix $CMD
  $BASE exec --nv --writable-tmpfs --bind=/projects/synergy_lab/garvit217,/cm/shared:/cm/shared,$TMPFS $imagefile python ddnet_inference.py --filepath $SLURM_JOBID --out_dir $SLURM_JOBID --epochs ${epochs} --batch ${batch_size} --lr ${lr} --dr ${dr}
else
  $BASE exec --nv --writable-tmpfs --bind=/projects/synergy_lab/garvit217,/cm/shared:/cm/shared,$TMPFS $imagefile python ddnet_inference.py --filepath $1 --out_dir $1 --epochs ${epochs} --batch ${batch_size} --lr ${lr} --dr ${dr}
fi





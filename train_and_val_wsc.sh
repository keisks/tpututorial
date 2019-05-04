#!/usr/bin/env bash
set -e
set -x
export PYTHONPATH=$(pwd)
tpuname="keisuke-tpu01"
bucket="keisuke-tpu-exp"
expdir="wsc-valid-uniq-eval-wsc2"
datadir="wsc-valid-uniq-eval-wsc2"
#batchsizes=( 8 16 32 64 )
#batchsizes=( 8 16 32 )
batchsizes=( 8 16 )
for s in "${batchsizes[@]}"
do
        #learningrates=( 1e-5 2e-5 5e-5 )
        learningrates=( 1e-5 3e-5 )
        for l in "${learningrates[@]}"
        do
                epochs=( 4 10 )
                for e in "${epochs[@]}"
                do
                        #warmups=( 0.1 0.2 )
                        warmups=( 0.2 )
                        for w in "${warmups[@]}"
                        do
                                python bert/run_bert.py \
                                  --output_dir=gs://${bucket}/${expdir}/batch-${s}_lr-${l}_epoch-${e}-warmup-${w}/ \
                                  --input_data=data/${datadir}/ \
                                  --do_lower_case=True \
                                  --max_seq_length=64 \
                                  --do_train=True \
                                  --predict_val=True \
                                  --predict_test=False \
                                  --train_batch_size=${s} \
                                  --predict_batch_size=256 \
                                  --learning_rate=${l} \
                                  --num_train_epochs=${e} \
                                  --warmup_proportion=${w} \
                                  --iterations_per_loop=1000 \
                                  --use_tpu=True \
                                  --tpu_name=${tpuname} \
                                  --bert_large=True \
                                  --num_labels 2 \
				  --task wsc
			done
		done
	done
done

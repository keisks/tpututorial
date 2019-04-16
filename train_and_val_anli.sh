#!/usr/bin/env bash
set -e
set -x
export PYTHONPATH=$(pwd)
batchsizes=( 8 16 32 64 )
for s in "${batchsizes[@]}"
do
	learningrates=( 1e-5 2e-5 3e-5 5e-5 )
	for l in "${learningrates[@]}"
	do
		epochs=( 3 4 10 )
		for e in "${epochs[@]}"
		do
			warmups=( 0.2 )
			for w in "${warmups[@]}"
			do
				python bert/run_bert.py \
				  --output_dir=gs://chandrab-tpu-tutorial/anli/batch-${s}_lr-${l}_epoch-${e}-warmup-${w}/ \
				  --input_data=data/anli/ \
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
				  --tpu_name=chandrab-tpu-anli \
				  --bert_large=True \
				  --num_labels 2 \
				  --task anli
			done
		done
	done
done

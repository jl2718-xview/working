model=${$(basename $1)%.*}
dir=$(dirname $1)
mkdir -p ./models/$model
python3 $dir/../../models/research/object_detection/model_main.py \
	--model_dir=$dir/../models/$model \
	--pipeline_config_path=$1 \
	--sample_1_of_n_eval_examples=10 \
	--alsologtostderr &

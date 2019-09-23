docker run --name g1 -P --gpus 1 -v $(realpath ..):/tf/xview -d jl2718/tensorflow:latest-py3-jupyter-models
docker port g1
docker exec g1 jupyter notebook list


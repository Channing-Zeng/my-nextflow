FROM mambaorg/micromamba:0.19.1

MAINTAINER alex

RUN \
    micromamba install -y -n base -c default -c bioconda -c conda-forge \
        python=3.7 \
	salmon=1.5.1 \
        fastqc=0.11.9 \
        multiqc=1.10.1 \
    && micromamba clean -a -y

ENV PATH /opt/conda/bin:$PATH
#python-utils=2.3.0


#  -c "http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge" \
#  -c "http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/linux-64" \
#  -c "http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/linux-64" \
#  -c "http://mirrors.ustc.edu.cn/anaconda/cloud/bioconda/linux-64" \
#  -c "http://mirrors.ustc.edu.cn/anaconda/pkgs/free/linux-64" \
#  -c "http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/linux-64" \
#  -c "http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/linux-64" \
#  -c "http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/" \


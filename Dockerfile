FROM ubuntu:22.04
RUN apt update && apt upgrade -y &&\
    apt install -y curl git tree unzip make build-essential cargo nodejs npm locales &&\
    locale-gen ja_JP.UTF-8 &&\
    echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

WORKDIR /opt
RUN git clone --depth 1 https://github.com/vim/vim.git -b v9.1.0448 &&\
    apt install -y libncurses-dev
WORKDIR /opt/vim
RUN ./configure --with-features=huge --prefix=/opt/vim &&\
    make &&\
    make install &&\
    echo 'export PATH="/opt/vim/bin:$PATH"' >> ~/.bashrc

WORKDIR /root
RUN mkdir config &&\
    curl -fsSL https://deno.land/x/install/install.sh | sh &&\
    echo 'export PATH="/root/.deno/bin:$PATH"' >> ~/.bashrc &&\
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

WORKDIR /volumes_dir
COPY vimrc /root/.vimrc
RUN echo "source /volumes_dir/extra_bashrc" >> /root/.bashrc

WORKDIR /volumes_dir/workdir
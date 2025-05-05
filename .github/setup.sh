# fetch update software list
sudo apt-get update

# give permissions
sudo chmod a+rwx ./
sudo chmod -R 777 ./

# install java
sudo apt install default-jre-headless
sudo apt install default-jdk-headless

# install julia
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.11.5-linux-x86_64.tar.gz
sudo tar zxvf julia-1.11.5-linux-x86_64.tar.gz
export PATH=$PATH:$(pwd)"/julia-1.11.5/bin"
printf "\nexport PATH=\"\$PATH:"$(pwd)"/julia-1.11.5/bin\"" >> ~/.bashrc

# install agents
julia --project=@. -e 'using Pkg; Pkg.instantiate()'

# install mesa
sudo apt install python3-pip
pip install mesa==2.1.4

# install netlogo
sudo wget http://ccl.northwestern.edu/netlogo/6.4.0/NetLogo-6.4.0-64.tgz
sudo tar -xzf NetLogo-6.4.0-64.tgz
sudo mv "NetLogo-6.4.0-64" netlogo

# install bc tool
sudo apt install bc

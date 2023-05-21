# fetch update software list
sudo apt-get update

# clone the repository and give permissions
sudo git clone https://github.com/JuliaDynamics/ABM_Framework_Comparisons.git
sudo cd test_comp
sudo chmod a+rwx ./
sudo chmod -R 777 ./

# install java
sudo apt install default-jre-headless
sudo apt install default-jdk-headless

# install julia
sudo wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.0-linux-x86_64.tar.gz
sudo tar zxvf julia-1.9.0-linux-x86_64.tar.gz
export PATH=$PATH:$(pwd)"/julia-1.9.0/bin"
printf "\nexport PATH=\"\$PATH:"$(pwd)"/julia-1.9.0/bin\"" >> ~/.bashrc

# install agents
julia --project=@. -e 'using Pkg; Pkg.instantiate()'

# install mesa
sudo apt install python3-pip
pip install mesa==1.2.1

# install netlogo
sudo wget http://ccl.northwestern.edu/netlogo/6.3.0/NetLogo-6.3.0-64.tgz
sudo tar -xzf NetLogo-6.3.0-64.tgz
sudo mv "NetLogo 6.3.0" netlogo

# install parallel and bc tools
sudo apt install parallel
sudo apt install bc

# run benchmarks
bash runall.sh

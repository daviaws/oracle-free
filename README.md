# HelloPhoenix

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

# nano
sudo apt update
sudo apt install nano -y

# swap
sudo fallocate -l 10G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo nano /etc/fstab
/swapfile none swap sw 0 0

# docker compose
sudo apt install -y curl jq

# Instalar pacotes requeridos
sudo apt install -y ca-certificates curl gnupg lsb-release

# Adicionar chave GPG oficial do Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adicionar repositório do Docker
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizar pacotes e instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add sudoers
sudo usermod -aG docker $USER

# Run Docker
docker build -t hello_phoenix .
docker run -it --rm -p 4000:4000 -e SECRET_KEY_BASE="KmsyXpjWSJXsF8yVCf7oehu3YXYJSyi6NzEmdpIdl6OXu+PD7gLtjH0Oe0AnyXGN" hello_phoenix

# Publish docker
docker tag hello_phoenix:latest daviaws/hello_phoenix:0.1.1
docker push daviaws/hello_phoenix:0.1.1
docker run -e SECRET_KEY_BASE="KmsyXpjWSJXsF8yVCf7oehu3YXYJSyi6NzEmdpIdl6OXu+PD7gLtjH0Oe0AnyXGN" -p 4000:4000 daviaws/hello_phoenix:0.1.0

# Provide in VM
sudo docker run -d \
  -e SECRET_KEY_BASE="KmsyXpjWSJXsF8yVCf7oehu3YXYJSyi6NzEmdpIdl6OXu+PD7gLtjH0Oe0AnyXGN" \
  -e PHX_HOST="$(curl -s https://ifconfig.me)" \
  -p 4000:4000 \
  daviaws/hello_phoenix:0.1.0

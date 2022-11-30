pragma solidity >=0.7.0 <0.9.0;

contract Cedula{
    struct Eleitor{
        uint peso;  //Acumulado por voto.
        bool jaVotou; //Se já votou.
        uint voto; //INDEX DO VOTO.
    }

    struct Candidato{
        //bytes32 nome;
        string nome;
        uint quantidadeVotos;
    }

    address public mesario;

    //Armazena um Eleitor para cada voto.
    mapping(address => Eleitor) public eleitores;

    //Cria um vetor de candidatos.
    Candidato [] public candidatos;

    constructor (string [] memory nomeCandidatos){
        mesario = msg.sender;
        eleitores[mesario].peso = 1;

        for(uint i = 0; i < nomeCandidatos.length; i++){
            //Inicia cada candidato com seu nome e com 0 número de votos.
            candidatos.push(Candidato({ nome: nomeCandidatos[i], quantidadeVotos: 0}));
        }
    }

    function darDireitoDeVoto(address eleitor) external{
        //Apenas o mesário pode dar o direito de voto.
        require(msg.sender == mesario);

        //Requer que o eleitor não tenha votado.
        require(!eleitores[eleitor].jaVotou);

        //Requer que o eleitor não tenha o direito ainda.
        require(eleitores[eleitor].peso == 0);

        //Atribui peso 1 ao eleitor.
        eleitores[eleitor].peso = 1;
    }

    function votar(uint candidato) external {
        Eleitor storage sender = eleitores[msg.sender];
        require(sender.peso != 0, "Eleitor nao tem direito de voto!");
        require(!sender.jaVotou, "Eleitor ja votou!");

        sender.jaVotou = true; //Contabiliza voto do eleitor.
        sender.voto = candidato; //Salva o candidato no eleitor.
        
        //Adiciona a quantidade de votos do eleitor no candidato.
        candidatos[candidato].quantidadeVotos += sender.peso;
    }

    function encontraVencedor() public view returns (uint candidatoVencedor_){
        uint votosVencedor = 0;
        for(uint p = 0; p < candidatos.length; p++){
            if(candidatos[p].quantidadeVotos > votosVencedor){
                votosVencedor = candidatos[p].quantidadeVotos;
                candidatoVencedor_ = p;
            }
        }
    }

    function candidatoVencedor() external view returns (string memory nomeVencedor){
        nomeVencedor = candidatos[encontraVencedor()].nome;
    }
}

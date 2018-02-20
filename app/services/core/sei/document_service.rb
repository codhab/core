module Core
  module Sei
    class DocumentService # :nodoc:
      def initialize(sei_system, sei_service, sei_unit = nil)
        @sei_system  = sei_system
        @sei_service = sei_service
        @sei_unit    = sei_unit # 110003219
      end

      def create_document(procede_id, subject, observation, interest)
        # procede_id 100000739
        # subject 06
        connect!
        procede = {"IdTipoProcedimento" => procede_id, "NivelAcesso" => 0, "Especificacao" => interest, "Assuntos" => subject, "Observacao" => observation, "IdHipoteseLegal" => nil}
        @response = @client.call(:gerar_procedimento,
                                  message: { SiglaSistema: @sei_system,
                                             IdentificacaoServico: @sei_service,
                                             IdUnidade: @sei_unit,
                                             Procedimento: procede,
                                             SinManterAbertoUnidade:'S',
                                             SinEnviarEmailNotificacao: 'N',
                                             Documentos: nil,
                                             ProcedimentosRelacionados: nil,
                                             UnidadesEnvio: nil,
                                             DataRetornoProgramado: nil,
                                             DiasRetornoProgramado: nil,
                                             SinDiasUteisRetornoProgramado: nil,
                                             IdMarcador: nil,
                                             TextoMarcador: nil
                                            })
      end

      def create_file(name, size, data, content)
        connect!
        @response = @client.call(:adicionar_arquivo,
                                  message: { SiglaSistema: @sei_system,
                                             IdentificacaoServico: @sei_service,
                                             IdUnidade: @sei_unit,
                                             Nome: name,
                                             Tamanho: size,
                                             Hash: data,
                                             Conteudo: content
                                            })
      end

      def send_document(proced,  files)
        connect!
        document = { "Tipo" => "R",
                     "ProtocoloProcedimento" => proced,
                     "IdSerie" => "831",
                     "NivelAcesso" => 1,
                     "Numero" => nil,
                     "Data" => Date.current.strftime('%d/%m/%Y'),
                     "Descricao" => nil,
                     "IdTipoConferencia" => nil,
                     "Remetente" => "APP",
                     "Interessados" => nil,
                     "Destinatarios" => nil,
                     "Observacao" => nil,
                     "NomeArquivo" => nil,
                     "Conteudo" => nil,
                     "ConteudoMTOM" => nil,
                     "IdArquivo" => files,
                     "IdHipoteseLegal" => nil,
                     "Campos" => nil,
                     "SinBloqueado" => 'S' }
        @response = @client.call(:incluir_documento,
                                  message: { SiglaSistema: @sei_system,
                                             IdentificacaoServico: @sei_service,
                                             IdUnidade: @sei_unit,
                                             Documento: document
                                            })
      end

      private

      def connect!
        @client = Savon.client(wsdl: 'http://treinamento3.sei.df.gov.br/sei/controlador_ws.php?servico=sei',
                               namespace: nil, encoding: 'UTF-8', env_namespace: :soap)
      end
    end
  end
end

# RepublicacaoProdutos

Contexto: 
O enjoei criou uma nova feature na plataforma, que permite que a pessoa que comprou um produto possa revender o mesmo produto reaproveitando o anuncio original. 

CRM:
Desenvolvi uma query que ativa uma segmentação de base no banco e envia para o salesforce todos os dias, para triggar uma automação e disparar um push diariamente. 

Segmentação: 
* Pessoas que compraram a 30 dias atrás
* do recebimento da compra até o momento atual não efetuaram uma devolução
* possuem status de pagamento aprovado (vendedor já recebeu o dinheiro)
* não duplicando transações (ex: se o usuário fez mais de uma transação no dia, enviar somente a que possui o maior ticket de valor) 

# Roadmap de Desenvolvimento

## Fase 0 - Estrutura Fundamental do Projeto

1. [ ] Configuração Base do Laravel 12 — Configurar ambiente de desenvolvimento com Laravel 12, instalação de dependências, setup do docker-compose com PostgreSQL e Redis, variáveis de ambiente e estrutura de pastas do projeto. `M`

2. [ ] Instalação e Configuração do Inertia.js + Vue.js — Integrar Inertia.js com Vue.js 3, configurar build pipeline com Vite, hot module replacement (HMR) e estrutura base de componentes reutilizáveis. `M`

3. [ ] Sistema de Autenticação Web — Implementar Laravel Sanctum/Passport com autenticação baseada em cookies para web, login, logout, reset de senha e middleware de autenticação. `L`

4. [ ] Modelo de Permissões (RBAC) — Estruturar sistema de roles (Proprietário, Veterinário, Operador, Consultor) com policies do Laravel e authorization gates para controlar acesso a recursos. `M`

5. [ ] Template Layout Base — Criar layout raiz com navegação responsiva, navbar com menu de contexto, sidebar com opções principais, footer e estrutura para tema claro/escuro. `M`

6. [ ] Autenticação Mobile/API — Implementar Laravel Sanctum com tokens para autenticação API, permitindo múltiplos tipos de client (web via cookie, mobile via token). `M`

7. [ ] Sistema de Auditoria Estrutural — Desenvolver middleware que registra automaticamente data, hora, usuário e mudanças em todas as entidades críticas, com modelo Audit para histórico consultável. `L`

## Fase 1 - Estrutura Hierárquica da Propriedade

8. [ ] Modelo e Migrations de Fazenda — Criar entidade Fazenda com campos (nome, localização, CNPJ, proprietário, ativo) e relacionamentos com usuários e demais recursos. `S`

9. [ ] CRUD de Fazenda — Implementar views e controllers para criar, editar, visualizar e desativar fazenda com validações, autenticação e permissões apropriadas. `M`

10. [ ] Dashboard de Fazenda — Criar página de contexto da fazenda mostrando informações principais, últimas atividades, quick stats (total animais, lotes, eventos recentes). `M`

11. [ ] Modelo de Áreas e Piquetes — Criar entidades de Área (divisão lógica da fazenda) e Piquete (pastagem/divisão física) com relacionamentos hierárquicos e associação a Fazenda. `S`

12. [ ] CRUD de Áreas e Piquetes — Implementar views e controllers para gerenciar áreas e piquetes, visualização em lista e mapa quando possível. `M`

13. [ ] Seletor de Contexto — Implementar widget para selecionar fazenda ativa em tempo real, alternando contexto e persistindo seleção em sessão/localStorage. `M`

14. [ ] Menu de Navegação Dinâmico — Estruturar menu principal que adapta-se com base no papel do usuário (proprietário vê mais, operador vê menos) e fazenda selecionada. `M`

## Fase 2 - Cadastro de Animais e Identidade

15. [ ] Modelo de Animal — Criar entidade Animal com campos de identificação (brinco, microchip, nome), categoria (matriz, touro, bezerro, novilha), sexo, data de nascimento, estado. `S`

16. [ ] CRUD de Animal — Implementar forms de cadastro com validações, busca por ID/nome/brinco, visualização de ficha e edição com controle de modificações. `L`

17. [ ] Histórico Genealógico — Criar relacionamentos de parentesco (pai, mãe) e estrutura de dados para árvore genealógica, com cálculo básico de consanguinidade. `M`

18. [ ] Visualização de Árvore Genealógica — Implementar componente Vue.js para renderizar árvore genealógica do animal (ascendentes e descendentes) de forma visual. `L`

19. [ ] Foto e Documentação do Animal — Permitir upload de foto do animal e documentação (certificado de registros, exames) com armazenamento em S3 e preview. `M`

20. [ ] Busca e Filtros Avançados — Implementar busca por múltiplos critérios (categoria, sexo, idade, lote, status) com paginação e exportação de resultados. `M`

21. [ ] Importação em Lote — Criar funcionalidade de upload CSV para importação massiva de animais com validação linha-a-linha e relatório de erros. `M`

## Fase 3 - Gestão do Ciclo Reprodutivo

22. [ ] Modelo de Eventos Reprodutivos — Criar entidades para Cio, Protocolo, IA, Diagnóstico, Gestação e Parto com relacionamentos estruturados e timestamps. `L`

23. [ ] Registro de Cio — Implementar formulário para registrar cio (data, observações) com alertas de cio esperado baseado em histórico anterior. `M`

24. [ ] Gestão de Protocolos de IA — Criar registro de protocolo de sincronização (tipo, data de início, medicações) com timeline visual do fluxo. `M`

25. [ ] Registro de IA e Cobertura — Implementar registro de inseminação artificial ou cobertura natural com data, hora, touro/reprodutor utilizado, responsável. `M`

26. [ ] Diagnóstico de Gestação — Criar registro de ultrassom/diagnóstico com data, resultado (gestante/não gestante), dias de gestação, observações do veterinário. `M`

27. [ ] Registro de Parto — Implementar registro de parto com data, tipo (normal/distócico), complicações, facilidade, viabilidade e geração automática de animal filho. `M`

28. [ ] Timeline Reprodutiva Visual — Criar componente Vue.js que visualiza timeline horizontal do ciclo reprodutivo (cio → protocolo → IA → diagnóstico → parto → lactação). `M`

29. [ ] Indicadores Reprodutivos Básicos — Implementar cálculo automático de intervalos (dias em cio, intervalo cio-IA, duração protocolo, intervalo entre partos) e exibição na ficha do animal. `M`

30. [ ] Relatório de Desempenho Reprodutivo — Gerar relatório consolidado com taxas (prenhez, sucesso IA, parturição) por protocolo, touro e período. `L`

## Fase 4 - Manejo Sanitário

31. [ ] Modelo de Eventos Sanitários — Criar entidades para Vacinação, Vermifugação, Medicamento, Ocorrência Clínica com campos de rastreamento (responsável, data, lote medicamento). `M`

32. [ ] Registro de Vacinação — Implementar formulário de vacinação com seleção de vacina (tipo, laboratório, lote), data e alertas de vencimento baseado em protocolo. `M`

33. [ ] Registro de Vermifugação — Criar registro de vermífugo com tipo de produto, dose, data e cálculo automático de próxima aplicação. `S`

34. [ ] Registro de Medicamentos — Implementar registro detalhado de medicamento (tipo, princípio ativo, dose, via, duração tratamento) com histórico farmacológico do animal. `M`

35. [ ] Gestão de Ocorrências Clínicas — Criar registro de problema de saúde (afecção/diagnóstico, data início, status, tratamento aplicado) com correlação a medicamentos e vacinações. `M`

36. [ ] Histórico Sanitário Consolidado — Implementar página com timeline sanitária completa do animal mostrando cronologia de eventos com filtros por tipo. `M`

37. [ ] Relatório Sanitário por Rebanho — Gerar relatório consolidado mostrando incidência de doenças, cobertura vacinal, medicamentos mais utilizados e tendências por período. `L`

## Fase 5 - Lotes e Movimentações

38. [ ] Modelo de Lote — Criar entidade Lote com nome, finalidade (engorda, reprodução, descarte), data de formação, status (ativo/inativo) e relacionamento com Fazenda. `S`

39. [ ] CRUD de Lote — Implementar formulários de criação, edição, visualização com lista de animais associados e histórico de movimentações. `M`

40. [ ] Associação Dinâmica de Animais — Implementar funcionalidade de adicionar/remover animais de lotes com rastreamento de data de entrada e saída. `M`

41. [ ] Modelo de Movimentação — Criar entidade Movimentação registrando deslocamento de animal/lote entre piquetes com data, hora, responsável e motivo. `S`

42. [ ] Registro de Movimentação — Implementar formulário para registrar movimentação individual ou em lote entre áreas/piquetes com validação de disponibilidade. `M`

43. [ ] Histórico de Ocupação de Piquetes — Criar visualização mostrando qual lote/animal ocupou qual piquete em qual período com timeline histórica. `M`

44. [ ] Dashboard de Movimentações — Implementar página mostrando movimentações recentes, lotes pendentes e sugestões de movimentação baseado em manejos. `M`

## Fase 6 - Pesagens e Manejo Nutricional

45. [ ] Modelo de Pesagem — Criar entidade Pesagem com data, animal, peso, responsável, observações e validação de ganho razoável entre pesagens. `S`

46. [ ] Registro de Pesagem Individual — Implementar formulário de pesagem com suporte a entrada manual e integração com balança digital quando disponível. `M`

47. [ ] Pesagem em Lote — Criar formulário para registrar pesagem múltipla de animais em lote (ex: pesar todos os animais de um grupo em um dia). `M`

48. [ ] Evolução de Ganho de Peso — Implementar gráficos mostrando evolução de peso por animal com cálculo de ganho médio diário (GMD) e comparação com metas. `M`

49. [ ] Comparação Entre Animais/Lotes — Criar relatório comparativo de ganho de peso entre diferentes animais ou lotes no mesmo período. `M`

50. [ ] Modelo de Dieta — Criar entidade Dieta especificando componentes (volumoso, concentrado, suplementos) com datas de vigência e associação a animais/lotes. `S`

51. [ ] CRUD de Dieta — Implementar formulários de criação e edição de dietas com lista de componentes e quantidade de alimento. `M`

52. [ ] Monitoramento Nutricional — Implementar dashboard mostrando animais com ganho de peso abaixo de meta ou que se desviam do padrão histórico. `M`

## Fase 7 - Estoque e Insumos

53. [ ] Modelo de Insumo — Criar entidade Insumo com tipo (vacina, medicamento, ração, suplemento), descrição, unidade de medida, preço unitário, fabricante. `S`

54. [ ] CRUD de Insumo — Implementar cadastro de insumos com validações, busca e categorização. `M`

55. [ ] Modelo de Estoque — Criar entidade Estoque registrando quantidade atual por insumo, data de atualização e entrada de movimentações. `S`

56. [ ] Registro de Entrada de Estoque — Implementar formulário para registrar compra/entrada de insumo com data, quantidade, preço, fornecedor. `M`

57. [ ] Integração Automática com Manejos — Ao registrar manejo (vacinação, medicamento), debitar automaticamente do estoque correspondente com rastreamento. `L`

58. [ ] Alertas de Reposição — Configurar nível mínimo por insumo e gerar alertas quando quantidade aproxima-se do limite. `S`

59. [ ] Relatório de Estoque e Consumo — Gerar relatório mostrando consumo histórico, quantidade disponível, projeção de reposição. `M`

## Fase 8 - Indicadores e Relatórios

60. [ ] Dashboard Executivo Base — Criar dashboard para proprietário com widgets de KPIs principais: número total de animais, quantidade por categoria. `M`

61. [ ] Indicadores Reprodutivos — Implementar cálculos e widgets de taxa de prenhez, intervalo entre partos, dias em cio, sucesso por protocolo. `M`

62. [ ] Indicadores Sanitários — Criar widgets mostrando incidência de doenças, taxa de vacinação, medicamentos aplicados, tendências. `M`

63. [ ] Indicadores Nutricionais — Implementar widgets de ganho médio diário, animais abaixo de meta, evolução de peso por categoria. `M`

64. [ ] Indicadores Financeiros Básicos — Criar widgets de custo operacional (medicamentos, ração), projeção de receita por venda. `L`

65. [ ] Relatório Customizável — Implementar ferramenta de geração de relatórios com seleção de período, filtros por lote/categoria e layout customizável. `L`

66. [ ] Exportação para Excel/PDF — Implementar exportação de relatórios e dados em formato Excel e PDF com formatação adequada. `L`

67. [ ] API de Dados para BI — Criar endpoints de API que expõem dados agregados em formato estruturado para integração com ferramentas de BI (Power BI, Tableau). `L`

## Fase 9 - Mobile e Offline

68. [ ] Prototipagem de Aplicação Mobile — Estruturar projeto de aplicação mobile (Vue.js Native ou React Native) com autenticação e sincronização. `L`

69. [ ] Sincronização de Dados Offline — Implementar banco de dados local (SQLite) e engine de sincronização que funciona offline e replica dados quando internet retorna. `XL`

70. [ ] Interface de Coleta de Manejo — Criar interface simplificada em mobile para registro rápido de eventos de manejo (vacinação, medicamento, pesagem) em campo. `L`

71. [ ] Suporte a Notificações Push — Implementar notificações push para alertas críticos (vacinação vencida, cio detectado, movimento sugerido). `M`

72. [ ] Modo Offline-First Completo — Testar funcionalidade offline em cenários sem sinal, validação local e sincronização quando sinal retorna. `L`

## Fase 10 - Integrações Avançadas

73. [ ] Integração com Brinco Eletrônico RFID — Implementar leitura de RFID para identificação automática de animal com API do leitor RFID. `L`

74. [ ] Integração com Balança Digital — Conectar balança para captura automática de peso, reduzindo entrada manual e erros. `L`

75. [ ] Webhooks para Integrações Externas — Implementar sistema de webhooks que notifica sistemas externos sobre eventos importantes (IA, parto, medicamento). `M`

76. [ ] API RESTful Pública — Criar API RESTful versioned com autenticação segura para integração com softwares de IA de terceiros e ERP. `L`

77. [ ] Documentação OpenAPI/Swagger — Gerar documentação automática da API com exemplos e client code generation. `M`

## Priorização e Dependências

> Notas
> - Fases são sequenciais: cada fase depende da anterior
> - Fase 0 é crítica e blocka todas as demais
> - Fases 1-3 (Estrutura, Animal, Reprodução) formam o MVP core
> - Fases 4-8 (Sanitário, Movimentação, Pesagem, Estoque, BI) ampliam funcionalidade
> - Fases 9-10 (Mobile, Integrações) são complementos avançados
> - Cada item representa uma funcionalidade completa e testável (frontend + backend)
> - Esforço estimado (XS=1d, S=2-3d, M=1w, L=2w, XL=3+w) considera complexidade, testes e integração
> - Sugestão: MVP inicial compreende Fases 0-3 (estrutura + animal + reprodução)

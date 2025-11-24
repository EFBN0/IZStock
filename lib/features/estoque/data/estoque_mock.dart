//import 'package:izstock/features/estoque/models/estoque.dart';
//import 'package:izstock/features/estoque/models/mercadoria.dart';
//
//const List<Mercadoria> kMercadoriasLivros = [
//  Mercadoria(
//    id: 101,
//    titulo: 'O Guia do Mochileiro das Galáxias',
//    descricao: 'A hilária saga de Arthur Dent pelo universo.',
//    valor: 45.50,
//    imagemUrl: 'https://placehold.co/150x150/673AB7/FFFFFF?text=Livro+1',
//  ),
//  Mercadoria(
//    id: 102,
//    titulo: 'Duna',
//    descricao: 'A jornada de Paul Atreides em Arrakis.',
//    valor: 89.90,
//    imagemUrl: 'https://placehold.co/150x150/673AB7/FFFFFF?text=Livro+2',
//  ),
//  Mercadoria(
//    id: 103,
//    titulo: 'O Nome do Vento',
//    descricao: 'A crônica de Kvothe, o matador do rei.',
//    valor: 65.00,
//    imagemUrl: 'https://placehold.co/150x150/673AB7/FFFFFF?text=Livro+3',
//  ),
//  Mercadoria(
//    id: 104,
//    titulo: 'Box Sherlock Holmes',
//    descricao: 'Todos os contos e romances do detetive.',
//    valor: 120.00,
//    imagemUrl: 'https://placehold.co/150x150/673AB7/FFFFFF?text=Livro+4',
//  ),
//];
//
//const List<Mercadoria> kMercadoriasDocesSalgados = [
//  Mercadoria(
//    id: 201,
//    titulo: 'Bolo de Pote (Chocolate)',
//    descricao: 'Bolo de chocolate com brigadeiro cremoso.',
//    valor: 10.00,
//    imagemUrl: 'https://placehold.co/150x150/E91E63/FFFFFF?text=Doce+1',
//  ),
//  Mercadoria(
//    id: 202,
//    titulo: 'Coxinha de Frango',
//    descricao: 'Salgado clássico com massa crocante.',
//    valor: 8.50,
//    imagemUrl: 'https://placehold.co/150x150/FF9800/FFFFFF?text=Salgado+1',
//  ),
//  Mercadoria(
//    id: 203,
//    titulo: 'Brownie Recheado',
//    descricao: 'Brownie com recheio de doce de leite.',
//    valor: 12.00,
//    imagemUrl: 'https://placehold.co/150x150/E91E63/FFFFFF?text=Doce+2',
//  ),
//];
//
//const List<Mercadoria> kMercadoriasColecionaveis = [
//  Mercadoria(
//    id: 301,
//    titulo: 'Funko Pop! Darth Vader',
//    descricao: 'Figura colecionável Star Wars - #01.',
//    valor: 149.90,
//    imagemUrl: 'https://placehold.co/150x150/4CAF50/FFFFFF?text=Funko+1',
//  ),
//  Mercadoria(
//    id: 302,
//    titulo: 'Card Pokémon (Charizard VMAX)',
//    descricao: 'Carta rara da coleção Escuridão Incandescente.',
//    valor: 250.00,
//    imagemUrl: 'https://placehold.co/150x150/4CAF50/FFFFFF?text=Card+1',
//  ),
//  Mercadoria(
//    id: 303,
//    titulo: 'HQ Sandman (Ed. Definitiva)',
//    descricao: 'Volume 1 da obra-prima de Neil Gaiman.',
//    valor: 99.90,
//    imagemUrl: 'https://placehold.co/150x150/4CAF50/FFFFFF?text=HQ+1',
//  ),
//];
//
// 3. LISTA PRINCIPAL DE ESTOQUES MOCKADOS
//
//final List<Estoque> kEstoquesMockados = [
//  Estoque(
//    id: 1,
//    titulo: 'Livros e HQs',
//    mercadorias: kMercadoriasLivros,
//  ),
//  Estoque(
//    id: 2,
//    titulo: 'Doces & Salgados',
//    mercadorias: kMercadoriasDocesSalgados,
//  ),
//  Estoque(
//    id: 3,
//    titulo: 'Colecionáveis',
//    mercadorias: kMercadoriasColecionaveis,
//  ),
//  Estoque(
//    id: 4,
//    titulo: 'Estoque Vazio (Teste)',
//    mercadorias: [], // Importante para testar o estado vazio da tela
//  ),
//];
//
// 4. (Opcional) UMA LISTA GLOBAL DE TODAS AS MERCADORIAS
//    Útil para a Tela 2.2 (Biblioteca de Itens)
//
//final List<Mercadoria> kTodasMercadoriasMockadas = [
//  ...kMercadoriasLivros,
//  ...kMercadoriasDocesSalgados,
//  ...kMercadoriasColecionaveis,
//];
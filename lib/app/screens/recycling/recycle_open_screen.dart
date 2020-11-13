import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matus_app/app/themes/app_colors.dart';

class RecyclingPageOpen extends StatelessWidget {
  final String text;
  final String image;

  String showRecycle(String text) {
    switch (text) {
      case 'Papel':
        return 'Aparas de papel, Jornais, Revistas, Caixas, Papelão, Papel de fax, Formulários de computador, Folhas de caderno, Cartolinas, Cartões, Rascunhos escritos, Envelopes, fotocópias, Folhetos, Impressos em geral.';
        break;
      case 'Plástico':
        return 'Tampas, Potes de alimentos, Frascos, Embalagens de refrigerante, Garrafas de água mineral, Recipientes para produtos de higiene e limpeza, PVC Tubos e conexões, Sacos plásticos em geral, Peças de brinquedos, Engradados de bebidas, Baldes.';
        break;
      case 'Metal':
        return 'Latas de alumínio, Latas de aço, Tampas, Ferragens, Canos, Esquadrias e molduras de quadros.';
        break;
      case 'Vidro':
        return 'Tampas, Potes, Frascos, Garrafas de bebidas, Copos, Embalagens.';
        break;
      case 'Peças':
        return 'Computadores, Monitores, Drives, Eletrodomésticos, Televisores, Impressoras, Fios eletrônicos.';
        break;
      case 'Bateria':
        return 'Pilhas de lítio recarregáveis, Íon lítio, Zinco-ar, Pilhas e baterias (celular, carro etc.).';
        break;
      case 'Madeira':
        return 'Dormentes, Paletes, Caixas de Madeira, Troncos e Galhos, Madeiras de demolição, portas, janelas, ripas, guarda-roupas, criado- mudo, camas, objetos em geral, Madeiras em geral proveniente da construção civil e outros setores.';
        break;
      case 'Óleo':
        return 'Óleo de cozinha, Óleo automotivo, Óleos hidráulicos, Óleos de circulação, Óleos de eletroerosão, Óleos lubrificantes em geral, Óleos para engrenagens industriais, Óleos de corte integrais, Óleos de têmpera, Óleos de brochamento, Fluidos utilizados em operações de lavagem de sistemas.';
        break;
      default:
        return '';
    }
  }

  String showNotRecycle(String text) {
    switch (text) {
      case 'Papel':
        return 'Adesivos, Etiquetas, Fita crepe, Papel carbono, Fotografias, Papel toalha, Papéis e guardanapos engordurados, Papéis metalizados, Parafinados ou plastificados.';
        break;
      case 'Plástico':
        return 'Cabos de panela, Tomadas, Isopor, Adesivos, Espuma, Teclados de computador, Acrílicos.';
        break;
      case 'Metal':
        return 'Clipes, Grampos, Esponjas de aço, Latas de tintas e Latas de combustível.';
        break;
      case 'Vidro':
        return 'Espelhos, Cristal, Ampolas de medicamentos, Cerâmicas e louças, Lâmpadas, Vidros temperados planos.';
        break;
      case 'Peças':
        return 'Fogões, Freezers, Geladeiras, Reatores, Toners.';
        break;
      case 'Bateria':
        return 'Baterias (AAA, AA, C, D, 9V).';
        break;
      case 'Madeira':
        return 'Madeira tratada ou contaminada (madeira tratada com conservantes ou anexada a outros materiais como gesso ou vidro de janela).';
        break;
      case 'Óleo':
        return 'Óleos contaminados com algum tipo de substância química (por exemplo, enxofre ativo.)';
        break;
      default:
        return '';
    }
  }

  const RecyclingPageOpen({Key key, this.text, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(text),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250.0,
                color: AppColor.secondaryColor,
                child: Align(
                  child: SvgPicture.asset(
                    image,
                    width: 150.0,
                    height: 150.0,
                  ),
                ),
              ),
              const Text(
                'Reciclaveis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  showRecycle(text),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const Divider(
                height: 40.0,
                thickness: 1.0,
              ),
              const Text(
                'Não Reciclaveis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  showNotRecycle(text),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Divider(
                height: 40.0,
                thickness: 1.0,
              ),
            ],
          ),
        ));
  }
}

// Classe Endereço do Anúncio
class AnnouncementAddress {
  String cep;
  String state;
  String city;
  String neighbornhood;

  // Contrutor com atributos opcionais
  AnnouncementAddress({this.cep, this.state, this.city, this.neighbornhood});

  // Transforma um Map em Object
  AnnouncementAddress.fromMap(Map<String, dynamic> map) {
    cep = map['cep'] as String;
    state = map['state'] as String;
    city = map['city'] as String;
    neighbornhood = map['neighbornhood'] as String;
  }

  // Transforma o Object em um Map
  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'state': state,
      'city': city,
      'neighbornhood': neighbornhood,
    };
  }

  // Cria uma Copia do Objeto
  AnnouncementAddress clone() {
    return AnnouncementAddress(
      cep: cep,
      state: state,
      city: city,
      neighbornhood: neighbornhood,
    );
  }
}

class Santri {
    int id;
    String name;
    String kelas;
    int saldo;
    int hutang;
    DateTime createdAt;
    DateTime updatedAt;
    Kartu kartu;

    Santri({
        required this.id,
        required this.name,
        required this.kelas,
        required this.saldo,
        required this.hutang,
        required this.createdAt,
        required this.updatedAt,
        required this.kartu,
    });

}

class Kartu {
    int id;
    String nomorKartu;
    DateTime createdAt;
    DateTime updatedAt;

    Kartu({
        required this.id,
        required this.nomorKartu,
        required this.createdAt,
        required this.updatedAt,
    });

}

import 'package:wav/wav.dart';

class wavProcess {
  Wav wav = null;

  void ReadFileSound(String filename) async {
    final wavtmp = await Wav.readFile(filename);

    this.wav = wavtmp;
  }

  void printFileData() {
    print(this.wav.format);
    print(this.wav.samplesPerSecond);
  }

  void writeFileToOtherfile(String filename) async{
    await this.wav.writeFile(filename);
  }
}
use feature 'say';
use utf8;
use Data::Printer;
my $pron_sing_nom = qr/jeg|du|han|hun/;
my $pron_sing_acc = qr/meg|deg|ham|henne/;


my $adv = qr/\QA\E|\QA.\E|\Qa\E|\Qa cappella\E|\Qa conto\E|\Qhurtig\E|\Qa konto\E|\Qà la carte\E|\Qà la grecque\E|\Qà la mode\E|\Qa posteriori\E|\Qa prima vista\E|\Qa priori\E|\Qa tempo\E|\Qa verbo\E|\Qa viso\E|\Qa vista\E|\Qad absurdum\E|\Qad acta\E|\Qad hoc\E|\Qad infinitum\E|\Qad notam\E|\Qad undas\E|\Qadagio\E|\Qakkurat\E|\Qakterifra\E|\Qal fresco\E|\Qal secco\E|\Qaldeles\E|\Qalders tid\E|\Qaldri\E|\Qaleine\E|\Qalene\E|\Qalias\E|\Qalle vegne\E|\Qallegretto\E|\Qallegro\E|\Qaller\E|\Qallerede\E|\Qallikevel\E|\Qalltid\E|\Qalltids\E|\Qalt\E|\Qaltfor\E|\Qaltså\E|\Qamok\E|\Qan\E|\Qana\E|\Qandante\E|\Qandantino\E|\Qandelsvis\E|\Qandfares\E|\Qandføttes\E|\Qandsynes\E|\Qannetsteds\E|\Qannetstedsfra\E|\Qannetstedshen\E|\Qanno\E|\Qanslagsvis\E|\Qanstendigvis\E|\Qanstigende\E|\Qantageligvis\E|\Qantakeligvis\E|\Qantydningsvis\E|\Qapropos\E|\Qargende\E|\Qat\E|\Qatt\E|\Qatter\E|\Qattpåtil\E|\Qattåt\E|\Qau\E|\Qaustenom\E|\Qav\E|\Qav dage\E|\Qav garde\E|\Qav gårde\E|\Qav lage\E|\Qav syne\E|\Qavdelingsvis\E|\Qavdragsvis\E|\Qavhendes\E|\Qavhends\E|\Qavsatsvis\E|\Qavslutningsvis\E|\Qbakenfra\E|\Qbakenom\E|\Qbaki\E|\Qbakk\E|\Qbaklengs\E|\Qbare\E|\Qbataljonsvis\E|\Qbedriftsvis\E|\Qbeint frem\E|\Qbeintfrem\E|\Qbeinveges\E|\Qbeinvegs\E|\Qbeinveis\E|\Qbekende\E|\Qbeklageligvis\E|\Qbelgende\E|\Qbenveges\E|\Qbenvegs\E|\Qbenveies\E|\Qbenveis\E|\Qbetids\E|\Qbi\E|\Qbidevind\E|\Qbis\E|\Qbistrende\E|\Qbitevis\E|\Qbitte\E|\Qbitterlig\E|\Qbitvis\E|\Qblanko\E|\Qblant anna\E|\Qblant annet\E|\Qblidelig\E|\Qblikk\E|\Qblikkende\E|\Qblott til lyst\E|\Qblottende\E|\Qbom\E|\Qbommende\E|\Qbona fide\E|\Qbortenom\E|\Qbortmed\E|\Qbrennfort\E|\Qbrutto\E|\Qbråfort\E|\Qbråtevis\E|\Qbto.\E|\Qbto\E|\Qbums\E|\Qbunkevis\E|\Qbuntevis\E|\Qbuntvis\E|\Qbus\E|\Qbøttevis\E|\Qca\E|\Qca.\E|\Qca\E|\Qcantabile\E|\Qcf\E|\Qcif\E|\Qcirka\E|\Qconcertando\E|\Qcoolly\E|\Qcrescendo\E|\Qda\E|\Qda capo\E|\Qdagevis\E|\Qdagstøtt\E|\Qdakapo\E|\Qdam\E|\Qdammende\E|\Qdann\E|\Qdann og vann\E|\Qd.c.\E|\Qd. c.\E|\Qd. d.\E|\Qd.d.\E|\Qde facto\E|\Qde jure\E|\Qdecrescendo\E|\Qdelkredere\E|\Qdels\E|\Qdelvis\E|\Qden dag i dag\E|\Qden gang\E|\Qdengang\E|\Qder\E|\Qder borte\E|\Qder hen\E|\Qder inne\E|\Qder nede\E|\Qder oppe\E|\Qder ute\E|\Qderav\E|\Qderborte\E|\Qderefter\E|\Qderetter\E|\Qderfor\E|\Qderfra\E|\Qderi\E|\Qderifra\E|\Qderigjennom\E|\Qderimot\E|\Qderinne\E|\Qdermed\E|\Qdernede\E|\Qdernest\E|\Qderom\E|\Qderomkring\E|\Qderover\E|\Qderpå\E|\Qdertil\E|\Qderved\E|\Qdess\E|\Qdessuaktet\E|\Qdessuten\E|\Qdessverre\E|\Qdesto\E|\Qdiminuendo\E|\Qdis\E|\Qdistriktsvis\E|\Qd.m\E|\Qd. m.\E|\Qd.m.\E|\Qdog\E|\Qdolce\E|\Qdoloroso\E|\Qdorgende\E|\Qdrita\E|\Qdryppende\E|\Qdrøssevis\E|\Qds.\E|\Qds\E|\Qdus\E|\Qdusinvis\E|\Qd.v.s.\E|\Qdvs\E|\Qd. v. s.\E|\Qdvs.\E|\Qdyende\E|\Qdøgnvis\E|\Qdønn\E|\Qdørg\E|\Qdørgende\E|\Qdørimellom\E|\Qd.å.\E|\Qd. å.\E|\Qe.f.\E|\Qe. f.\E|\Qe f\E|\Qefterhvert\E|\Qei\E|\Qeiende\E|\Qeinkom\E|\Qeitrende\E|\Qe. Kr.\E|\Qe Kr\E|\Qe.Kr.\E|\Qe.Kr\E|\Qeks\E|\Qeksemlpelvis\E|\Qeksempelvis\E/;

my %hash;
my @string = qw(på en hurtig måte vi på en elegant måte slå på gamle aper);

foreach $_ (@string) {
    if ( $_ =~ /($adv)/g ) {
    $hash{$_} = $1;
    }
}
p %hash;

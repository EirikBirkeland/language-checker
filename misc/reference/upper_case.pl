use feature 'say';

$source = "Chrome";
$target = "CHROME";

if ($target =~ /^[A-Z]+$/) {
say "$target is all UC";
} else {
say "$target is mixed-case";
}

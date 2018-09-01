use strict;
use warnings;
use Benchmark 'cmpthese';

my @sub_code = <DATA>;
my %SUBS =
    (
    sqrt => 1,
    CloseHandle => 2,
    addch => 2,
    Beep => 2,
    FillConsoleOutputCharacter => 2,
    GetConsoleScreenBufferInfo => 2,
    GetLargestConsoleWindowSize => 2,
    GetStdHandle => 2,
    move => 2,
    ReadConsoleInput => 2,
    SetConsoleCursorPosition => 2,
    SetConsoleMode => 2,
    SetConsoleTextAttribute => 2,
    SetConsoleTitle => 2,
    WriteConsole => 2
    );

cmpthese( -1, {
               'Original' => 'original ()',
               'dave_the_m' => 'dave_the_m ()',
               'rnahi' => 'rnahi ()',
               'borisz' => 'borisz ()',
               'ikegami' => 'ikegami ()',
               'anon' => 'anon ()',
             } );


sub anon
{
my @subs;

foreach my $line ( @sub_code )
{
    if ($line =~ /[^a-zA-Z]([a-zA-Z_]+[a-zA-Z_0-9]*)[^a-zA-Z]*\(/
        and exists $SUBS{$1})
    { push @subs, $1 }
}
}

sub ikegami
{
my @subs;

foreach my $line ( @sub_code ) {
   if ( $line =~ /(\w+)\(/ ) {
      if ( exists $SUBS{$1} ) {
         push( @subs, $1 );
      }
   }
}
}

sub original
{
my @subs;

foreach my $line ( @sub_code ) {
    foreach my $sub ( keys %SUBS ) {
        push @subs, $sub if $line =~ /[^a-zA-Z]$sub[^a-zA-Z]*\(/;
    }
}
}

sub dave_the_m
{
my @subs;

foreach my $sub ( keys %SUBS ) {
    my $re = qr/[^a-zA-Z]$sub[^a-zA-Z]*\(/;
    foreach my $line ( @sub_code ) {
        if ( $line =~ $re ) { push( @subs, $sub) }
    }
}
}

sub rnahi
{
my @subs;

my $code = join("", @sub_code);

foreach my $sub ( keys %SUBS ) {
    while  ( $code =~ /\b$sub\b\(/g )
    {
         push( @subs, $sub ) ;
    }
}
}

sub borisz
{
my @subs;
my $str = join '|', sort { length $b <=> length $a } keys %SUBS;
my $re = qr/[^a-zA-Z]($str)[^a-zA-Z]*\(/;
/$re/ and push @subs, $1 for ( @sub_code );
}

__DATA__
/* Dumb curses implementation for Win32 port
 */

#include "curses.h"

static HANDLE _conin;
static HANDLE _conout;

void
wclear( Window * w )
{
    COORD sz, xy = { 0, 0 };
    DWORD wrote;
    sz = GetLargestConsoleWindowSize( _conout );
    FillConsoleOutputCharacter( _conout, ' ', sz.X * sz.Y, xy, &wrote );
}

void
attron( unsigned short attr )
{
    SetConsoleTextAttribute( _conout, attr );
}

void
attroff( unsigned short attr )
{
    SetConsoleTextAttribute( _conout, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE );
}

void
move( int y, int x )
{
    COORD xy = { x, y };
    SetConsoleCursorPosition( _conout, xy );
}

void
mvaddstr( int y, int x, const char * str )
{
    DWORD wrote;
    move( y,x );
    WriteConsole( _conout, str, strlen( str ), &wrote, 0 );
}

void
addch( int ch )
{
    DWORD wrote;
    WriteConsole( _conout, &ch, 1, &wrote, 0 );
}

void
mvaddch( int y, int x, int ch )
{
    move( y, x );
    addch( ch );
}

void
wclrtoeol( Window * w )
{
    CONSOLE_SCREEN_BUFFER_INFO info;
    DWORD wrote;
    GetConsoleScreenBufferInfo( _conout, &info );
    FillConsoleOutputCharacter( _conout, ' ', info.dwSize.X - info.dwCursorPosition.X,
                                info.dwCursorPosition, &wrote );
}

void
wrefresh( Window * w )
{
    /* Do nothing - all changes are immediate */
}

int
wgetch( Window * w )
{
    INPUT_RECORD in;
    DWORD got;
    while( 1 )
    {
        do
            ReadConsoleInput( _conin, &in, 1, &got );
        while( KEY_EVENT != in.EventType || 0 == in.Event.KeyEvent.bKeyDown );
        /* Translate direction keys into vi(1) motion */
        switch( in.Event.KeyEvent.wVirtualKeyCode )
        {
        case VK_LEFT:  return 'h';
        case VK_RIGHT: return 'l';
        case VK_UP:    return 'k';
        case VK_DOWN:  return 'j';

        /* Ignore standard modifier keys */
        case VK_SHIFT:
        case VK_CONTROL:
        case VK_MENU:
                continue;
        }
        return in.Event.KeyEvent.uChar.AsciiChar;
    }
}

void
beep( void )
{
    Beep( 650, 250 );
}

void
noecho( void )
{
    /* Do nothing */
}

void
raw( void )
{
    SetConsoleMode( _conin, ENABLE_PROCESSED_INPUT );
}

int
initscr( void )
{
    _conin = GetStdHandle( STD_INPUT_HANDLE );
    _conout = GetStdHandle( STD_OUTPUT_HANDLE );
    SetConsoleTitle( "Sudoku" );
    return 1;
}

void
endwin( void )
{
    CloseHandle( _conin );
    CloseHandle( _conout );
}

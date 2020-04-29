module termcolors;

import std.stdio;
import std.conv;
import std.regex;

void usage() {
   write(
      "colors [#]123456 [--display]\n"
      ~ "   Prints the ANSI escape code for the foreground true color\n"
      ~ "   If the display flag is present, prints an example\n"
   );
}

static auto reset = "\x1b[0m";

string ff(string inp) {
   return inp.to!uint(16).to!string();
}

int main(string[] args) {
   if (args.length > 3) {
      writeln("Too many args!");
      usage();
      return 1;
   }

   if (args.length == 1) {
      writeln("Expected a color!");
      usage();
      return 1;
   }

   auto hexcolor = args[1];
   auto hexcolor_regex = ctRegex!("^#?([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$");
   auto match = hexcolor.matchFirst(hexcolor_regex);
   if (!match) {
      writeln(hexcolor ~ " is not a valid hex color!");
      usage();
      return 1;
   }

   auto ansi_core = ";2;" ~ match[1].ff() ~ ";" ~ match[2].ff() ~ ";" ~ match[3].ff() ~ "m";

   if (args.length == 3) {
      if (args[2] == "--display") {
         writeln("\x1b[48" ~ ansi_core ~ "  " ~ reset);
         writeln("\x1b[38" ~ ansi_core ~ "Aa" ~ reset);
         return 0;
      } else {
         writeln("Unknown argument " ~ args[2] ~ "!");
         usage();
         return 1;
      }
   }
   write("\x1b[38" ~ ansi_core);
   return 0;
}

# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Pascal < RegexLexer
      tag 'pascal'
      aliases 'freepascal', 'pascal', 'pas', 'delphi'
      filenames '*.pas'
      mimetypes 'text/x-pascal'

      title 'Pascal'
      desc 'Pascal...'

      # TODO: support more of unicode
      id = /@?[_a-z]\w*/i

      keywords = %w(
        and array begin break case continue const div do downto else end except finally for forward function goto if interface label mod nil not of or procedure program raise repeat result shl shr string then to try type unit until uses var while with xor as class dispose except exit exports finalization finally inherited initialization is library new on out property raise self threadvar try absolute abstract alias assembler cdecl cppdecl default export external forward index local name nostackframe oldfpccall override pascal private protected public published read register reintroduce safecall softfloat stdcall virtual write far near and array as asm begin case class const constructor destructor dispinterface div do downto else end except exports file finalization finally for function goto if implementation in inherited initialization inline interface is label library mod nil not object of or out packed procedure program property raise record repeat resourcestring set shl shr string then threadvar to try type unit until uses var while with xor readln writeln
      )

      keywords_type = %w(
        byte shortint word smallint longword cardinal longint integer int64 single currency double extended char widechar ansichar shortstring string ansistring widestring boolean array
      )

      state :whitespace do
        rule /\s+/m, Text
        rule %r(//.*?\n), Comment::Single
        rule %r(/[*].*?[*]/)m, Comment::Multiline
        rule %r(/[{].*?[}]/)m, Comment::Multiline
      end

      state :root do
        mixin :whitespace

        rule /^\s*\[.*?\]/, Name::Attribute
        rule /[$]\s*'/, Str, :splice_string
        rule /[$]\s*<#/, Str, :splice_recstring
        rule /<#/, Str, :recstring
        rule /(<\[)\s*(#{id}:)?/, Keyword
        rule /\]>/, Keyword
        rule /[~!%^&*()+=|\[\]{}:;,.<>\/?-]/, Punctuation
        rule /'(\\.|.)*?['\n]/, Str
        rule /'(\\.|.)'/, Str::Char
        rule /0x[0-9a-f]+[lu]?/i, Num
        rule %r(
          [0-9]
          ([.][0-9]*)? # decimal
          (e[+-][0-9]+)? # exponent
          [fldu]? # type
        )ix, Num

        rule /\b(#{keywords.join('|')})\b/, Keyword
        rule /\b(#{keywords_type.join('|')})\b/, Keyword::Type
        rule /type|record/, Keyword, :class
        rule /namespace|using/, Keyword, :namespace
        rule /#{id}(?=\s*[(])/, Name::Function
        rule id, Name
      end

      state :class do
        mixin :whitespace
        rule id, Name::Class, :pop!
      end

      state :namespace do
        mixin :whitespace
        rule /(?=[(])/, Text, :pop!
        rule /(#{id}|[.])+/, Name::Namespace, :pop!
      end

    end
  end
end
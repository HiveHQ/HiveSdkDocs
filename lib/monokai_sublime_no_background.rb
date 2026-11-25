# Rouge's monokai.sublime theme, without the background it gives names and
# plain text.
#
# Since Rouge 3 (the version in the slatedocs/slate image the Dockerfile
# builds with), that theme paints those tokens #272822, which shows as patches
# on the code blocks' $code-bg. Rouge 2, which built this site before, didn't.
module Rouge
  module Themes
    class MonokaiSublimeNoBackground < MonokaiSublime
      name 'monokai.sublime.nobg'

      style Name::Variable::Class,
            Name::Namespace,
            Name::Label,
            Name::Entity,
            Name::Builtin::Pseudo,
            Name::Variable::Global,
            Name::Variable::Instance,
            Name::Variable,
            Text::Whitespace,
            Text,
            Name,                             :fg => :white
    end
  end
end

# encoding: utf-8

module OlccsPlugins
  class Plopify
    include Singleton

    def initialize
      @plop_words = %w(pl0p co1n pika plip zzZz burp meuuh kikoo pouet prout gaaaa moule miaou plooop gnegne gargle blabla limule gloups nartaaa gruiiik blouark fluèèrk ka-pika glouglou kapouééé buarrgll coincoin fmelebele mollusque coccimule pschiittt croucroute piiikachuu bzzoïïnnng rastakouère wolfenstein porteninwak britneycdkey super-tomate eviv-bulgroz obiwan-kenobi bananemagique eingousef)
      @plop_density = 75
    end

    def process(message)
      message.split.collect { |m| replace(m) }.join(' ')
    end

    def replace(w)
      if rand(100) < @plop_density
        return @plop_words.sample
      end

      return w
    end
  end
end
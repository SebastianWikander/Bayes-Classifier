# Common words, not to be classified
$common_words =  {"the"=>1,"of"=>2,"to"=>3,"and"=>4,"a"=>5,"in"=>6,"is"=>7,"it"=>8,"you"=>9,"that"=>10,"he"=>11,"was"=>12,"for"=>13,"on"=>14,"are"=>15,"with"=>16,"as"=>17,"I"=>18,"his"=>19,"they"=>20,"be"=>21,"at"=>22,"one"=>23,"have"=>24,"this"=>25,"from"=>26,"or"=>27,"had"=>28,"by"=>29,"hot"=>30,"but"=>31,"some"=>32,"what"=>33,"there"=>34,"we"=>35,"can"=>36,"out"=>37,"other"=>38,"were"=>39,"all"=>40,"your"=>41,"when"=>42,"up"=>43,"use"=>44,"word"=>45,"how"=>46,"said"=>47,"an"=>48,"each"=>49,"she"=>50,"which"=>51,"do"=>52,"their"=>53,"time"=>54,"if"=>55,"will"=>56,"way"=>57,"about"=>58,"many"=>59,"then"=>60,"them"=>61,"would"=>62,"write"=>63,"like"=>64,"so"=>65,"these"=>66,"her"=>67,"long"=>68,"make"=>69,"thing"=>70,"see"=>71,"him"=>72,"two"=>73,"has"=>74,"look"=>75,"more"=>76,"day"=>77,"could"=>78,"go"=>79,"come"=>80,"did"=>81,"my"=>82,"sound"=>83,"no"=>84,"most"=>85,"number"=>86,"who"=>87,"over"=>88,"know"=>89,"water"=>90,"than"=>91,"call"=>92,"first"=>93,"people"=>94,"may"=>95,"down"=>96,"side"=>97,"been"=>98,"now"=>99,"find"=>100,"any"=>101,"new"=>102,"work"=>103,"part"=>104,"take"=>105,"get"=>106,"place"=>107,"made"=>108,"live"=>109,"where"=>110,"after"=>111,"back"=>112,"little"=>113,"only"=>114,"round"=>115,"man"=>116,"year"=>117,"came"=>118,"show"=>119,"every"=>120,"good"=>121,"me"=>122,"give"=>123,"our"=>124,"under"=>125,"name"=>126,"very"=>127,"through"=>128,"just"=>129,"form"=>130,"much"=>131,"great"=>132,"think"=>133,"say"=>134,"help"=>135,"low"=>136,"line"=>137,"before"=>138,"turn"=>139,"cause"=>140,"same"=>141,"mean"=>142,"differ"=>143,"move"=>144,"right"=>145,"boy"=>146,"old"=>147,"too"=>148,"does"=>149,"tell"=>150,"sentence"=>151,"set"=>152,"three"=>153,"want"=>154,"air"=>155,"well"=>156,"also"=>157,"play"=>158,"small"=>159,"end"=>160,"put"=>161,"home"=>162,"read"=>163,"hand"=>164,"port"=>165,"large"=>166,"spell"=>167,"add"=>168,"even"=>169,"land"=>170,"here"=>171,"must"=>172,"big"=>173,"high"=>174,"such"=>175,"follow"=>176,"act"=>177,"why"=>178,"ask"=>179,"men"=>180,"change"=>181,"went"=>182,"light"=>183,"kind"=>184,"off"=>185,"need"=>186,"house"=>187,"picture"=>188,"try"=>189,"us"=>190,"again"=>191,"animal"=>192,"point"=>193,"mother"=>194,"world"=>195,"near"=>196,"build"=>197,"self"=>198,"earth"=>199,"father"=>200,"head"=>201,"stand"=>202,"own"=>203,"page"=>204,"should"=>205,"country"=>206,"found"=>207,"answer"=>208,"school"=>209,"grow"=>210,"study"=>211,"still"=>212,"learn"=>213,"plant"=>214,"cover"=>215,"food"=>216,"sun"=>217,"four"=>218,"thought"=>219,"let"=>220,"keep"=>221,"eye"=>222,"never"=>223,"last"=>224,"door"=>225,"between"=>226,"city"=>227,"tree"=>228,"cross"=>229,"since"=>230,"hard"=>231,"start"=>232,"might"=>233,"story"=>234,"saw"=>235,"far"=>236,"sea"=>237,"draw"=>238,"left"=>239,"late"=>240,"run"=>241,"don't"=>242,"while"=>243,"press"=>244,"close"=>245,"night"=>246,"real"=>247,"life"=>248,"few"=>249,"stop"=>250,"reuter"=>251,"reuter"=>251,"reuter"=>251}

class Classifier
  def initialize(*categories)
    @categories = Hash.new
  	categories.each { |category| @categories[category] = Hash.new 0 }
    @category_word_total = Hash.new 0
  	@category_count = Hash.new 0
    @vocabulary = Hash.new 0
  	@alpha = 1.0
  end

  # Training data
  def train(category, text)
    @category_count[category] += 1
    text.split(" ").each do |word|
      @categories[category][word] += 1
      @category_word_total[category] += 1
      @vocabulary[word] += 1
    end
  end

  def naive_bayes(text)
    score = Hash.new 0
    category_total = @category_count.inject(0) { |sum, cat| sum += cat[1] }
    @categories.each do |category, category_words|
      # Probability for the category P(category)
      score[category] = Math.log(@category_count[category].to_f/category_total.to_f)
      text.split(" ").uniq.each do |word|
        # Probability for the word in category P(word(i)|category)
        # adjusted using add one smoothing
        if !$common_words.has_key? word
          score[category] += Math.log(
            (category_words[word].to_f + @alpha)/(@category_word_total[category] + @alpha*@vocabulary.length))
        end
      end
    end
    score.max_by{|k,v| v}.first.to_s
  end
end

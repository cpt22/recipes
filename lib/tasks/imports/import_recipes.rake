namespace :import do
  desc "Takes a docx file from Julie as input and structures and imports the contained recipes"
  task :recipes, [:user_email, :path_to_recipe_file, :categories, :debug] => :environment do |rake_task, args|
    abort("Missing User Email") if args[:user_email].blank?
    abort("Missing File") if args[:path_to_recipe_file].blank?


    doc = Docx::Document.open(args[:path_to_recipe_file])

    recipes = []

    current_recipe = nil
    is_default_ingredient_group = true

    # Load all recipes into the hash
    doc.paragraphs.each do |p|
      html = p.to_html
      html_as_string = html.to_s
      string_contents = p.to_s
      to_print = ""

      # Get titles
      if html_as_string.include?("font-size:18pt")
        title = string_contents
        next if title.blank?
        current_recipe = {
          name: title,
          creator: "",
          ingredients: [],
          instructions: ""
        }
        recipes << current_recipe
        is_default_ingredient_group = true
        to_print = "Title -- #{title} --"

      # Handle Bolded Lines
      elsif is_default_ingredient_group && html_as_string.include?("<strong>") && string_contents.include?("  ")
        parts = string_contents.split("  ", 2)
        parts[0].strip!
        parts[1] = parts[1].strip.titleize unless parts[1].nil?
        current_recipe[:ingredients].push({
          quantity: parts[0].split(" ", 2)[0],
          unit: parts[0].split(" ", 2)[1],
          ingredient: parts[1]
        })
        to_print = "Ingredient -- qty:#{parts[0]},, ing:#{parts[1] unless parts[1].nil?} --"

      elsif is_default_ingredient_group && string_contents.include?("&&")
        string_contents.slice!("&&")
        string_contents = string_contents.strip.titleize
        current_recipe[:ingredients].push({
          quantity: "",
          unit: "",
          ingredient: string_contents
        })

        to_print = "Ingredient -- ing:#{string_contents} --"

      # Handle creator
      elsif string_contents.downcase.include?("from the kitchen of")
        string_contents.downcase!
        string_contents.slice!("from the kitchen of")
        name = string_contents.titleize.strip
        current_recipe[:creator] = name
        to_print = "Creator -- #{name} --"

      # Handle if its not a person
      elsif html_as_string.include?('<p style="font-size:12pt;">') && string_contents.include?("from")
        string_contents.downcase!
        string_contents.slice!("from")
        name = string_contents.titleize.strip
        current_recipe[:creator] = name
        to_print = "Creator -- #{name} --"

      # Handle Blank lines
      elsif string_contents == "" || string_contents.include?("***")
        to_print =  "Empty -- "

      # Handle other text for the instructions
      else
        is_default_ingredient_group = false
        final_contents = string_contents
        if html_as_string.include?("<em>")
          final_contents = "<em>#{final_contents}</em>"
        end
        if html_as_string.include?("<strong>")
          final_contents = "<strong>#{final_contents}</strong>"
        end
        current_recipe[:instructions] << final_contents << "<br>"
        to_print = "Instruction -- #{string_contents} --"
      end

      puts to_print << "   #{html_as_string}" if args[:debug].present? && args[:debug] == true
    end

    # Build recipes in Database
    user = User.find_by_email(args[:user_email])
    categories = []
    if args[:categories].present?
      JSON.parse(args[:categories]).each{|c| categories << Category.find_by_name(c)}
      categories.compact
    end

    ActiveRecord::Base.transaction do
      begin
        recipes.each do |r|
          next if r[:name].blank?
          creator = r[:creator].blank? ? "Gail Prassas" : r[:creator]
          recipe = Recipe.create!(name: r[:name], content: r[:instructions], creator: creator, user: user, imported: true)
          recipe.categories << categories

          recipe.recipe_ingredients << r[:ingredients].collect{|i| recipe.recipe_ingredients.build(quantity: i[:quantity], unit: i[:unit], ingredient: Ingredient.find_or_create_by(name: i[:ingredient]))}
          recipe.save!
        end
        puts "Created #{recipes.count} Recipes from #{args[:path_to_recipe_file]}"

      rescue Exception => e
        ActiveRecord::Rollback
        puts "There was an error importing recipes from #{args[:path_to_recipe_file]} ::: #{e}"
      end
    end
  end
end

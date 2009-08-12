module Chingu
  
  module InputHelpers
    #
    # Dispatches :symbols => actions by readint the hash "input"
    #
    def dispatch_input
      return if input.nil?
      
      input.each do |symbol, action|
        if button_down?(Input::SYMBOL_TO_CONSTANT[symbol])
          dispatch_action(object, action)
        end
      end
    end
    
    #
    # For a given object, dispatch "action".
    # An action can be:
    #
    # * Symbol (:p, :space), translates into a method-call
    # * Proc/Lambda, call() it
    # * GameState-instance, push it on top of stack
    # * GameState-inherited class, create a new instance, cache it and push it on top of stack
    #
    def dispatch_action(object, action)
      if action.is_a? Symbol
        object.send(action)
      elsif action.is_a? Proc
        action.call
      elsif action.is_a? Chingu::GameState
        push_game_state(action)
      elsif action.superclass == Chingu::GameState
        push_game_state(action)
      end
    end
  end

  #
  # push_game_state accepts either a class inherited from GameState or an object-instance from such a class.
  #
  # push_game_state(Intro):
  # game state mananger will create a new Intro-object first time called and cache it.
  #
  # push_game_state(Intro.new):
  # The first line ends up calling "new" to Intro before activating the newly created game state.
  # Each time 'push_game_state(Intro.new)' is called a new Intro-object will be created.
  # Usefull for stuff like: push_game_state(Level.new(:level_nr => 11))
  #
  module GameStateHelpers
    def push_game_state(state, options = {})
      $window.game_state_manager.push_state(state, options)      
    end
  
    def pop_game_state(options)
      $window.game_state_manager.pop_state(options)
    end

    def current_game_state
      $window.game_state_manager.current_state
    end

    def previous_game_state
      $window.game_state_manager.previous_state
    end

    def clear_game_states
      $window.game_state_manager.clear_states
    end
  end

  #
  # Various helper-methods to manipulate the screen
  #
  module DrawHelpers
    #
    # Fills whole window with color 'c'
    #
    def fill(c)
      $window.draw_quad(0,0,c,$window.width,0,c,$window.width,$window.width,c,0,$window.height,c,0,:default)
    end
     
    #
    # Fills a given Rect 'r' with color 'c'
    #
    def fill_rect(r, c)
      $window.draw_quad(r.x,r.y,c, r.right,r.y,c, r.right,r.bottom,c, r.x,r.bottom,c,0,:default)
    end
     
    def fade(options = {})
    end
  end
  
  module GameObjectHelpers
    #
    # Fetch game objects of a certain type/class
    #
    def game_objects_of_class(klass)
      @game_objects.select { |game_object| game_object.is_a? klass }
    end
  end

end
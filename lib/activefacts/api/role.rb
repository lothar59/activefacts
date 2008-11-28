## The ActiveFacts Runtime API Concept class
# Copyright (c) 2008 Clifford Heath. Read the LICENSE file.
#
module ActiveFacts
  module API

    # A Role represents the relationship of one object to another (or to a boolean condition).
    # Relationships (or binary fact types) have a Role at each end; one is declared using _has_one_
    # or _one_to_one_, and the other is created on the counterpart class. Each Concept class maintains
    # an array of the roles it plays.
    class Role
      attr_accessor :name
      attr_accessor :counterpart      # All roles except unaries have a binary counterpart
      attr_accessor :player           # May be a Symbol, which will be converted to a Class/Concept
      attr_accessor :unique
      attr_accessor :mandatory
      attr_accessor :value_restriction

      def initialize(player, counterpart, name, mandatory = false, unique = true)
        @player = player
        @counterpart = counterpart
        @name = name
        @mandatory = mandatory
        @unique = unique
      end

      def unary?
        # N.B. A role with a forward reference looks unary until it is resolved.
        counterpart == nil
      end

      def resolve_player(vocabulary)  #:nodoc:
        return @player if Class === @player   # Done already
        klass = vocabulary.concept(@player)   # Trigger the binding
        raise "Cannot resolve role player #{@player.inspect} for role #{name} in vocabulary #{vocabulary.basename}; still forward-declared?" unless klass
        @player = klass                       # Memoize a successful result
      end

      def adapt(constellation, value) #:nodoc:
        # If the value is a compatible class, use it (if in another constellation, clone it),
        # else create a compatible object using the value as constructor parameters.
        if @player === value  # REVISIT: may be a non-primary subtype of player
          # Check that the value is in a compatible constellation, clone if not:
          if constellation && (vc = value.constellation) && vc != constellation
            value = value.clone   # REVISIT: There's sure to be things we should reset/clone here, like non-identifying roles
          end
          value.constellation = constellation if constellation
        else
          value = [value] unless Array === value
          raise "No parameters were provided to identify an #{@player.basename} instance" if value == []
          if constellation
            value = constellation.send(@player.basename.to_sym, *value)
          else
            value = @player.new(*value)
          end
        end
        value
      end
    end

    # Every Concept has a Role collection
    # REVISIT: You can enumerate the concept's own roles, or inherited roles as well.
    class RoleCollection < Hash #:nodoc:
      def verbalise
        keys.sort_by(&:to_s).inspect
      end
    end

    # A RoleValueArray is an array with all mutating methods hidden.
    # We use these for the "many" side of a 1:many relationship.
    # Only "replace" and "delete" are actually used (so far!).
    #
    # Don't rely on this implementation, as it must change to support
    # persistence.
    #
    class RoleValueArray < Array  #:nodoc:
      [ :"<<", :"[]=", :clear, :collect!, :compact!, :concat, :delete,
        :delete_at, :delete_if, :fill, :flatten!, :insert, :map!, :pop,
        :push, :reject!, :replace, :reverse!, :shift, :shuffle!, :slice!,
        :sort!, :uniq!, :unshift
      ].each{|s|
          begin
            alias_method("__#{s}", s)
          rescue NameError  # shuffle! is in 1.9 only
          end
        }

      def verbalise
        "["+map{|e| e.verbalise}*", "+"]"
      end
    end

  end
end

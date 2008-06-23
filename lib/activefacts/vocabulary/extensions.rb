#
# Extensions to the ActiveFacts Vocabulary API (which is generated from the Metamodel)
# Copyright (c) 2008 Clifford Heath. Read the LICENSE file.
#
module ActiveFacts
  module Metamodel

    class FactType
      def all_reading_by_ordinal
        all_reading.sort_by{|reading| reading.ordinal}
      end

      def preferred_reading
        all_reading_by_ordinal[0]
      end

      def describe(highlight = nil)
        (entity_type ? entity_type.name : "")+
        '('+all_role.map{|role| role.describe(highlight) }*", "+')'
      end
    end

    class Role
      def describe(highlight = nil)
        concept.name + (self == highlight ? "*" : "")
      end
    end

    class RoleSequence
      def describe
#        fact_types = all_role_ref.map(&:role).map(&:fact_type).uniq
#        fact_types.size.to_s+" FTs, "+
        "("+
        all_role_ref.map{|role_ref| role_ref.role.concept.name }*", "+
        ")"
      end
    end

    class EntityType
      def preferred_identifier
        if fact_type
          # For a nested fact type, the PI is a unique constraint over N or N-1 roles
          fact_roles = fact_type.all_role
          debug "Looking for PI on nested fact type #{name}" do
            pi = catch :pi do
                fact_roles.each{|r|                       # Try all roles of the fact type
                    r.all_role_ref.map{|rr|               # All role sequences that reference this role
                        role_sequence = rr.role_sequence

                        # The role sequence is only interesting if it cover only this fact's roles
                        next if role_sequence.all_role_ref.size < fact_roles.size-1
                        next if role_sequence.all_role_ref.size > fact_roles.size
                        next if role_sequence.all_role_ref.detect{|rsr| !(ft = rsr.role.fact_type) || ft != fact_type }

                        # This role sequence is a candidate
                        pc = role_sequence.all_presence_constraint.detect{|c|
                            c.is_preferred_identifier
                          }
                        throw :pi, pc if pc
                      }
                  }
                throw :pi, nil
              end
            debug "Got PI #{pi.name} for nested #{name}" if pi
            debug "Looking for PI on entity that nests this fact" unless pi
            raise "Oops, pi for nested fact is #{pi.class}" unless !pi || PresenceConstraint === pi
            return pi if pi
          end
        end

        debug "\nLooking for PI for ordinary entity #{name} with #{all_role.size} roles:" do
          debug "Roles are in fact types #{all_role.map{|r| r.fact_type.describe(r)}*", "}"
          pi = catch :pi do
              all_supertypes = supertypes_transitive
              debug "PI roles must be played by one of #{all_supertypes.map(&:name)*", "}" if all_supertypes.size > 1
              all_role.each{|role|
                  ftroles = role.fact_type.all_role
                  next if ftroles.size > 2        # Skip roles in objectified fact types

                  debug "Considering role in #{role.fact_type.describe(role)}"

                  # Find the related role which must be included in any PI:
                  # Note this works with unary fact types:
                  pi_role = ftroles.size == 1 || ftroles[1] == role ? ftroles[0] : ftroles[1]

                  next if ftroles.size == 2 && pi_role.concept == self
                  debug "\tConsidering #{pi_role.concept.name} as a PI role"

                  # Look in all role sequences that include this related role
                  pi_role.all_role_ref.each{|rr|
                      role_sequence = rr.role_sequence  # A role sequence that includes a possible role
                      debug "\t\tConsidering role sequence #{role_sequence.describe}"

                      # All roles in this role_sequence to fact types
                      # which (apart from that role) only have roles
                      # played by the original entity type or a supertype.
                      next if role_sequence.all_role_ref.detect{|rsr|
                          fact_type_roles = rsr.role.fact_type.all_role
                          residual_roles = fact_type_roles-[rsr.role]
                          residual_roles.detect{|rfr|
                              !all_supertypes.include?(rfr.concept)
                            }
                        }

                      # Any presence constraint over this role sequence is a candidate
                      rr.role_sequence.all_presence_constraint.detect{|pc|
                          # Found it!
                          if pc.is_preferred_identifier
                            debug "found PI #{pc.name}, is_preferred_identifier=#{pc.is_preferred_identifier.inspect}, enforcement=#{pc.enforcement}"
                            throw :pi, pc
                          end
                        }
                    }
                }
              throw :pi, nil
            end
          raise "Oops, pi for entity is #{pi.class}" if pi && !(PresenceConstraint === pi)
          debug "Got PI #{pi.name} for #{name}" if pi

          if !pi
            if (supertype = identifying_supertype)
              debug "PI not found for #{name}, looking in supertype #{supertype.name}"
              pi = supertype.preferred_identifier
            else
              debug "No PI found for #{name}"
            end
          end
          raise "No PI found for #{name}" unless pi
          pi
        end
      end

      # An array all direct supertypes
      def supertypes
        all_type_inheritance_by_subtype.map{|ti|
            ti.supertype
          }
      end

      # An array of self followed by all supertypes in order:
      def supertypes_transitive
          ([self] + all_type_inheritance_by_subtype.map{|ti|
              # debug ti.class.roles.verbalise; exit
              ti.supertype.supertypes_transitive
            }).flatten.uniq
      end

      # A subtype does not have a identifying_supertype if it defines its own identifier
      def identifying_supertype
        debug "Looking for identifying_supertype of #{name}"
        all_type_inheritance_by_subtype.detect{|ti|
            debug "considering supertype #{ti.supertype.name}"
            next unless ti.provides_identification
            debug "found identifying supertype of #{name}, it's #{ti.supertype.name}"
            return ti.supertype
          }
        debug "Failed to find identifying supertype of #{name}"
        return nil
      end
    end

  end
end

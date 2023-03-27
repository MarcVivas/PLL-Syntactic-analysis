//
// Created by marc on 26/03/23.
//

#include "Automata.h"

void Automata::add_transition(std::string src_state, char input, std::string dst_state) {
    this->transitions[src_state][input] = dst_state;
}

void Automata::add_start_state(std::string state) {
    this->start_states.insert(state);
}

void Automata::add_accepting_state(std::string state)  {
    this->accepting_states.insert(state);
}

void Automata::add_alphabet_letter(char c){
    this->alphabet.insert(c);
}

void Automata::add_intermediate_state(std::string state){
    this->intermediate_states.insert(state);
}

/**
 * Minimize the automata
 */
Automata& Automata::minimize() {
    // First, we need to create two partitions: one with accepting states and one with non-accepting states
    // We will use a queue to keep track of the partitions we need to split

    std::vector<std::set<std::string>> equivalence_class;
    equivalence_class.push_back(*(this->get_accepting_states()));
    equivalence_class.push_back(this->get_non_accepting_states());


    // If the previous equivalence class is the same as the previous the automata is minimized
    bool equivalence_class_changed = true;
    while(equivalence_class_changed){

        equivalence_class_changed = false;

        std::vector<std::set<std::string>> next_equivalence_class = this->get_next_equivalence_class(&equivalence_class);

        // Check if the equivalence class has changed
        if (next_equivalence_class.size() > equivalence_class.size()) {
            equivalence_class_changed = true;
        }

        // Update current equivalence_class
        equivalence_class = next_equivalence_class;
    }


    // Update the automata
    this->update_automata(&equivalence_class);

    return *this;
}



void Automata::update_automata(std::vector<std::set<std::string>> *equivalence_class){

    // For each state in the equivalence class, create a new state in the new automaton
    std::map<std::string, std::string> new_states;
    for (const auto& state_set : *equivalence_class) {
        std::string new_state  = "{ ";
        for (const auto& state : state_set) {
            new_state += state + " ";
        }
        new_state += "}";
        for (const auto& state : state_set) {
            new_states[state] = new_state;
        }
    }


    // Create a new map to store the transitions of the minimized automaton
    std::map<std::string, std::map<char, std::string>> new_transitions;

    // Compute the transitions of the minimized automaton
    for (const auto& state : this->get_all_states()) {
        for (const auto& transition : transitions[state]) {
            std::string from_state = new_states[state];
            std::string to_state = new_states[transition.second];
            new_transitions[from_state][transition.first] = to_state;
        }
    }


    // Create a new set of accepting states by finding the equivalence class that contains the original accepting states
    std::set<std::string> new_accepting_states;
    for (const auto& state_set : *equivalence_class) {
        bool contains_accepting = false;
        for (const auto& state : state_set) {
            if (this->accepting_states.count(state) > 0) {
                contains_accepting = true;
                break;
            }
        }
        if (contains_accepting) {
            for (const auto& state : state_set) {
                new_accepting_states.insert(new_states[state]);
            }
        }
    }

    // Create a new set of initial states by finding the equivalence class that contains the original initial states
    std::set<std::string> new_initial_states;
    for (const auto& state_set : *equivalence_class) {
        bool contains_initial = false;
        for (const auto& state : state_set) {
            if (this->start_states.count(state) > 0) {
                contains_initial = true;
                break;
            }
        }
        if (contains_initial) {
            for (const auto& state : state_set) {
                new_initial_states.insert(new_states[state]);
            }
        }
    }

    // Create a new set of intermediate states by finding the equivalence class that contains the original intermediate states
    std::set<std::string> new_intermediate_states;
    for (const auto& state_set : *equivalence_class) {
        bool contains_intermediate = false;
        for (const auto& state : state_set) {
            if (this->intermediate_states.count(state) > 0) {
                contains_intermediate = true;
                break;
            }
        }
        if (contains_intermediate) {
            for (const auto& state : state_set) {
                new_intermediate_states.insert(new_states[state]);
            }
        }
    }



    this->transitions = new_transitions;
    this->accepting_states = new_accepting_states;
    this->start_states = new_initial_states;
    this->intermediate_states = new_intermediate_states;
}




/**
 * Get the next equivalence class
 * @return
 */
std::vector<std::set<std::string>>  Automata::get_next_equivalence_class(std::vector<std::set<std::string>>  *equivalence_class){

    // Here we will store the next equivalence class
    std::vector<std::set<std::string>> next_equivalence_class;

    // For each group inside the equivalence class
    for(const auto & state_set : *equivalence_class){

        // If the state set has only 1 state, add it to the next equivalence class
        if (state_set.size() == 1){
            next_equivalence_class.push_back(state_set);
            continue;
        }

        // Here we will store the sets the states can go
        std::map<std::string, std::set<std::string>> groups;

        // For each state inside a group
        for(auto & state : state_set){
            std::set<std::string> group; // Here we store the sets the current state can go

            // For each transition of the state
            for(auto & transition : this->transitions[state]){

                // For each group inside the equivalence class
                for( const auto & set : *equivalence_class){
                    if(set.count(transition.second) > 0){
                        // The current state can go to the set group using one transition
                        group.insert(set.begin(), set.end());
                        break;
                    }
                }
            }
            std::string key;
            for (auto & elem: group){
                key += elem;
            }
            groups[key].insert(state);
        }

        // Add new sets to the next_equivalence class
        for (auto& group : groups) {
            next_equivalence_class.push_back(group.second);
        }
    }

    return next_equivalence_class;

}



/**
 * Get all the states that are not final
 * @return
 */
std::set<std::string> Automata::get_non_accepting_states(){
    std::set<std::string> non_accepting;
    for (auto& state : get_all_states()) {
        if (this->get_accepting_states()->count(state) == 0) {
            non_accepting.insert(state);
        }
    }
    return non_accepting;
}

std::ostream& operator<<(std::ostream& os, const Automata& automata) {

    os << "Start states: ";
    for (const auto& state : automata.start_states) {
        os << state << " ";
    }
    os << std::endl;

    os << "Accepting states: ";
    for (const auto& state : automata.accepting_states) {
        os << state << " ";
    }
    os << std::endl;

    os << "Intermediate states: ";
    for (const auto& state : automata.intermediate_states) {
        os << state << " ";
    }
    os << std::endl;

    os << "Alphabet: ";
    for (const auto& letter : automata.alphabet) {
        os << letter << " ";
    }
    os << std::endl;

    os << "Transitions:" << std::endl;
    for (const auto& src_state : automata.transitions) {
        for (const auto& input : src_state.second) {
            os << src_state.first << " ... " << input.second << " [symbol=\"" << input.first << "\"];" << std::endl;
        }
    }


    return os;
}


std::set<std::string> Automata::get_all_states() {
    std::set<std::string> all_states;
    all_states.insert(accepting_states.begin(), accepting_states.end());
    all_states.insert(intermediate_states.begin(), intermediate_states.end());
    all_states.insert(start_states.begin(), start_states.end());
    return all_states;
}

std::set<std::string> * Automata::get_start_states(){ return &this->start_states;}
std::set<std::string> * Automata::get_accepting_states() { return &this->accepting_states;}
std::map<std::string, std::map<char, std::string>> * Automata::get_transitions(){return &this->transitions;}
std::set<char> * Automata::get_alphabet(){return &this->alphabet;}




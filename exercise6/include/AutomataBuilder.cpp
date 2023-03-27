//
// Created by marc on 26/03/23.
//

#include "AutomataBuilder.h"


void AutomataBuilder::add_transition(std::string src_state, char input, std::string dst_state)  {
    // Check if the source and destination states exist
    if (automaton.get_all_states().find(src_state) == automaton.get_all_states().end()) {
        std::cerr << "Transition error: Source state "<< src_state <<" does not exist.\n";
        return;
    }
    if (automaton.get_all_states().find(dst_state) == automaton.get_all_states().end()) {
        std::cerr << "Transition error: Destination state " << dst_state << " does not exist.\n";
        return;
    }
    // Check if the input is in the alphabet
    if (automaton.get_alphabet()->find(input) == automaton.get_alphabet()->end()) {
        std::cerr << "Transition error: Letter " << input << " is not in the alphabet.\n";
        return;
    }
    automaton.add_transition(src_state, input, dst_state);}

void AutomataBuilder::add_accepting_state(std::string state) {
    automaton.add_accepting_state(state);
}

Automata AutomataBuilder::build() {
    // Check if there is at least one start state and one accepting state
    if (automaton.get_start_states()->empty()) {
        std::cerr << "No start states specified.\n";
    }
    if (automaton.get_accepting_states()->empty()) {
        std::cerr << "No accepting states specified.\n";
    }
    return this->automaton;
}

void AutomataBuilder::add_start_state(std::string state) {
    automaton.add_start_state(state);
}

void AutomataBuilder::add_alphabet_letter(char c){
    automaton.add_alphabet_letter(c);
}

void AutomataBuilder::add_intermediate_state(std::string state) {
    automaton.add_intermediate_state(state);
}

void AutomataBuilder::resetBuilder(){
    this->automaton = Automata();
}
//
// Created by marc on 26/03/23.
//

#include "AutomataBuilder.h"


void AutomataBuilder::add_transition(std::string src_state, char input, std::string dst_state)  {
    // Check if the source and destination states exist
    if (automaton.get_all_states().find(src_state) == automaton.get_all_states().end()) {
        throw std::invalid_argument("Source state does not exist.");
    }
    if (automaton.get_all_states().find(dst_state) == automaton.get_all_states().end()) {
        throw std::invalid_argument("Destination state does not exist.");
    }
    // Check if the input is in the alphabet
    if (automaton.get_alphabet()->find(input) == automaton.get_alphabet()->end()) {
        throw std::invalid_argument("Input is not in the alphabet.");
    }
    automaton.add_transition(src_state, input, dst_state);}

void AutomataBuilder::add_accepting_state(std::string state) {
    automaton.add_accepting_state(state);
}

Automata AutomataBuilder::build() {
    // Check if there is at least one start state and one accepting state
    if (automaton.get_start_states()->empty()) {
        throw std::invalid_argument("No start states specified.");
    }
    if (automaton.get_accepting_states()->empty()) {
        throw std::invalid_argument("No accepting states specified.");
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
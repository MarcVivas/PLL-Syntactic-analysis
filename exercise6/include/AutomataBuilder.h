//
// Created by marc on 26/03/23.
//

#ifndef PLL_SYNTACTIC_ANALYSIS_AUTOMATABUILDER_H
#define PLL_SYNTACTIC_ANALYSIS_AUTOMATABUILDER_H


class AutomataBuilder {
public:
    AutomataBuilder() {}

    void add_alphabet_letter(char c);


    void add_transition(std::string src_state, char input, std::string dst_state);

    void add_start_state(std::string state);

    void add_accepting_state(std::string state);

    void add_intermediate_state(std::string state);


    void resetBuilder();

    Automata build();

private:
    Automata automaton;
};


#endif //PLL_SYNTACTIC_ANALYSIS_AUTOMATABUILDER_H

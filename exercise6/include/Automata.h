//
// Created by marc on 26/03/23.
//

#ifndef PLL_SYNTACTIC_ANALYSIS_AUTOMATA_H
#define PLL_SYNTACTIC_ANALYSIS_AUTOMATA_H


class Automata {
public:
    Automata() = default;

    void add_transition(std::string src_state, char input, std::string dst_state);

    void add_start_state(std::string state);

    void add_accepting_state(std::string state);

    void add_alphabet_letter(char c);

    void add_intermediate_state(std::string state);

    Automata& minimize();

    friend std::ostream& operator<<(std::ostream& os, const Automata& automata);

    std::set<std::string> * get_start_states();
    std::set<std::string> * get_accepting_states();
    std::map<std::string, std::map<char, std::string>> * get_transitions();
    std::set<char> * get_alphabet();
    std::set<std::string> get_all_states();
    std::set<std::string> get_non_accepting_states();


private:
    std::map<std::string, std::map<char, std::string>> transitions;
    std::set<std::string> accepting_states;
    std::set<std::string> start_states;
    std::set<std::string> intermediate_states;
    std::set<char> alphabet;
    std::vector<std::set<std::string>>  get_next_equivalence_class(std::vector<std::set<std::string>> *equivalence_class);
    void update_automata(std::vector<std::set<std::string>> *equivalence_class);
};


#endif //PLL_SYNTACTIC_ANALYSIS_AUTOMATA_H

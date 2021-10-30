#ifndef LEARN_H_INCLUDED
#define LEARN_H_INCLUDED

#include <unordered_map>
#include "types.h"

enum class PersistedLearningUsage
{
	Off = 1,
	Standard = 2,
	Self = 3,
};
extern PersistedLearningUsage usePersistedLearning;
void setUsePersistedLearning();

struct LearningMove
{
    ShashChess::Depth depth = 0;
    ShashChess::Value score = ShashChess::VALUE_NONE;
    ShashChess::Move move = ShashChess::MOVE_NONE;
	int performance = 100;
};

struct PersistedLearningMove
{
    ShashChess::Key key;
	LearningMove learningMove;
};

class LearningData
{
private:
    bool isPaused;
    bool needPersisting;
    std::unordered_multimap<ShashChess::Key, LearningMove*> HT;
    std::vector<void*> mainDataBuffers;
    std::vector<void*> newMovesDataBuffers;

private:
    bool load(const std::string& filename);
    void insert_or_update(PersistedLearningMove* plm, bool qLearning);

public:
    LearningData();
    ~LearningData();

    void clear();
    void init();
    void persist();

    void pause();
    void resume();
    bool is_paused();

    void add_new_learning(ShashChess::Key key, const LearningMove &lm);

    int probe(ShashChess::Key key, const LearningMove*& learningMove);
    const LearningMove *probe_move(ShashChess::Key key, ShashChess::Move move);
};

extern LearningData LD;

#endif // #ifndef LEARN_H_INCLUDED

#include <stdatomic.h>
#include <assert.h>
#include <stdbool.h>

// A simple lock-free hash table as described in
// https://preshing.com/20130605/the-worlds-simplest-lock-free-hash-table/

#ifndef SIZE
#define SIZE 2
#endif
_Static_assert ((SIZE & (SIZE - 1)) == 0, "SIZE must be a power of 2");

struct Entry {
    atomic_int key;
    atomic_int value;
};

struct Entry m_entries[SIZE];

inline static uint32_t integerHash(uint32_t h)
{
	// h ^= h >> 16;
	// h *= 0x85ebca6b;
	// h ^= h >> 13;
	// h *= 0xc2b2ae35;
	// h ^= h >> 16;
	return h;
}

void init() {
    for (int i = 0; i < SIZE; i++) {
        atomic_init(&m_entries[i].key, 0);
        atomic_init(&m_entries[i].value, 0);
    }
}

void set(uint32_t key, uint32_t value)
{
    assert(key != 0);
    assert(value != 0);

    for (uint32_t idx = integerHash(key);; idx++)
    {
        idx &= SIZE - 1;

        // Load the key that was there.
        uint32_t probedKey = atomic_load_explicit(&m_entries[idx].key, memory_order_relaxed);
        if (probedKey != key) {
            // The entry was either free, or contains another key.
            if (probedKey != 0)
                continue;           // Usually, it contains another key. Keep probing.
                
            // The entry was free. Now let's try to take it using a CAS.
            int expected = 0;
            bool is_successful = atomic_compare_exchange_strong_explicit(&m_entries[idx].key, &expected, key, memory_order_relaxed, memory_order_relaxed);
            // If CAS failed, expected was updated.
            if ((expected != 0) && !is_successful)
                continue;       // Another thread just stole it from underneath us.

            // Either we just added the key, or another thread did.
        }
        
        // Store the value in this array entry.
        atomic_store_explicit(&m_entries[idx].value, value, memory_order_relaxed);
        return;
    }
}

uint32_t get(uint32_t key)
{
    assert(key != 0);

    for (uint32_t idx = integerHash(key);; idx++)
    {
        idx &= SIZE - 1;

        uint32_t probedKey = atomic_load_explicit(&m_entries[idx].key, memory_order_relaxed);
        if (probedKey == key)
            return atomic_load_explicit(&m_entries[idx].value, memory_order_relaxed);
        if (probedKey == 0)
            return 0;          
    }
}

uint32_t count()
{
    uint32_t itemCount = 0;
    for (uint32_t idx = 0; idx < SIZE; idx++)
    {
        if ((atomic_load_explicit(&m_entries[idx].key, memory_order_relaxed) != 0)
            && (atomic_load_explicit(&m_entries[idx].value, memory_order_relaxed) != 0))
            itemCount++;
    }
    return itemCount;
}
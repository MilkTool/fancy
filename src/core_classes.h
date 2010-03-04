#ifndef _CORE_METHODS_H_
#define _CORE_METHODS_H_

extern Class *ObjectClass;
extern Class *NilClass;
extern Class *TClass;
extern ClassInstance *nil;
extern ClassInstance *t;


void init_core_classes();
void init_global_objects();

/**
 * Sets up the global scope with predefined functions etc.
 */
void init_global_scope();

#endif /* _CORE_METHODS_H_ */

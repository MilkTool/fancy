#include "includes.h"

Hash::Hash() : NativeObject()
{
}

Hash::Hash(map<FancyObject_p, FancyObject_p> map) :
  NativeObject(),
  mappings(map)
{
}

Hash::~Hash()
{
}

FancyObject_p Hash::operator[](FancyObject_p key) const
{
  map<FancyObject_p, FancyObject_p>::const_iterator citer = this->mappings.find(key);
  
  if (citer == this->mappings.end()) {
    // throw UnknownIdentifierError("Unknown key object!");
    return 0;
  }
  
  return (*citer).second;
}

FancyObject_p Hash::set_value(FancyObject_p key, FancyObject_p value)
{
  this->mappings[key] = value;
  return value;
}

NativeObject_p Hash::equal(const NativeObject_p other) const
{
  if(!IS_HASH(other))
    return nil;

  Hash_p other_hash = (Hash_p)other;
  if((*this) == (*other_hash))
    return t;
  return nil;
}

FancyObject_p Hash::eval(Scope *scope)
{
  return RegexClass->create_instance(this);
}

OBJ_TYPE Hash::type() const
{
  return OBJ_HASH;
}

string Hash::to_s() const
{
  stringstream s;
  s << "{ ";

  for(map<FancyObject_p, FancyObject_p>::const_iterator iter = this->mappings.begin(); iter != this->mappings.end(); iter++) {
    s << iter->first->to_s();
    s << " => ";
    s << iter->second->to_s();
    s << " ";
  }

  s << "}";
  return s.str();
}

bool Hash::operator==(const Hash& other) const
{
  for(map<FancyObject_p, FancyObject_p>::const_iterator iter = this->mappings.begin(); 
      iter != this->mappings.end(); 
      iter++) {
    if(iter->first->equal(other[iter->first]) == nil) {
      return false;
    }
  }
  return true;
}

int Hash::size() const
{
  return this->mappings.size();
}

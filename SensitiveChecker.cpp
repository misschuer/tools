#include "SensitiveChecker.h"

struct Node {

	int child[kind];
	int fail;
	int id;
	int cnt;
	int fa;
	void init() {
		memset(child, 0, sizeof(child));
		fail = -1, id = 0, cnt = 0, fa = -1;
	}
};

int root;
int tot;
int que[maxn];
Node T[maxn];
int head;
int tail;

static int init(lua_State *L) {
	root = tot = 0;
	T[root].init();
	return 0;
}

static int getIndex(unsigned char ch) {
	return ch;
}

static int query(const char* s) {
	int ans = 0;
	int p = 0, q, t;
	for (int i = 0; s[i]; ++i) {

		int index = getIndex(s[ i ]);
		p = T[p].child[index];
		if (T[p].cnt) {

			ans += T[p].cnt;
			T[p].cnt = 0;
			for (q = p; q != root; q = T[q].fail) {

				for (t = T[q].fail; T[t].cnt > 0; t = T[t].fail) {

					ans += T[t].cnt;
					T[t].cnt = 0;
				}
			}
		}
	}
	return ans;
}

static int insert(lua_State *L) {
	const char* s = luaL_checkstring(L, 1);
	int id = luaL_checknumber(L, 2);

	int p = root, index, q;
	for (int i = 0; s[i]; ++i) {

		index = getIndex(s[i]);
		if (!T[p].child[index]) {

			T[++tot].init();
			T[p].child[index] = tot;
		}
		q = p;
		p = T[p].child[index];
		T[p].fa = q;
	}
	T[p].id = id;
	T[p].cnt++;

	return 0;
}

static int build_ac_auto(lua_State *L) {
	head = tail = 0;
	que[tail++] = root;
	while (head < tail) {

		int u = que[head++];
		for (int i = 0; i < kind; ++i) {

			if (T[u].child[i]) {

				int son = T[u].child[i];
				int p = T[u].fail;
				if (u == root) T[son].fail = root;
				else T[son].fail = T[p].child[i];
				que[tail++] = son;
			}
			else {//trieͼ£¬ʨ¶¨ѩŢ½ڵ

				int p = T[u].fail;
				if (u == root) T[u].child[i] = root;
				else T[u].child[i] = T[p].child[i];
			}
		}
	}

	return 0;
}

static int contains(lua_State *L) {
	const char* s = luaL_checkstring(L, 1);
	int p = 0;
	bool ret = false;
	for (int i = 0; s[i]; ++i) {
		int index = getIndex(s[i]);
		p = T[p].child[index];
		if (T[p].cnt) {
			ret = true;
			break;
		}
	}

	lua_pushboolean(L, ret);
	return 1;
}

static const struct luaL_Reg luaLoadFun[] = {
	{ "init", init },
	{ "insert", insert },
	{ "build_ac_auto", build_ac_auto },
	{ "contains", contains },
	{ NULL, NULL }
};

int luaopen_libchecker(lua_State *L) {
	luaL_register(L, "libchecker", luaLoadFun); // lua 5.1
	//luaL_newlib(L, luaLoadFun);
	return 1;
}

int main() {

	//int ts;
	//int n;
	//char s[maxn];

	//scanf("%d", &ts);
	//while (ts--) {

	//	init();
	//	scanf("%d%*c", &n);
	//	for (int i = 0; i < n; ++i) {
	//		scanf("%s", s);
	//		insert(s, i);
	//	}
	//	build_ac_auto();
	//	scanf("%s", s);
	//	printf("%d\n", contains(s));
	//}
	return 0;
}

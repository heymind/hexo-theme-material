class CateTree
    constructor:(@cates,@helper)->
        @tree = {cid:0,subs:[]}
        cates.forEach (cate)=>
            @makeInTree(cate)
        console.log(@tree.subs)
    query:(cid,tree)->
        if tree.cid is cid
            return tree
        for sub in tree.subs
            result=@query(cid,sub)
            if result
                return result
        return null
    makeInTree:(obj)->
        return if @query(obj._id,@tree)
        unless obj.parent
            @tree.subs.push(@warpInTree(obj))
            return
        parent = @query(obj.parent,@tree)
        parent = @makeInTree(obj.parent) unless parent
        parent.subs.push(@warpInTree(obj))

    warpInTree:(obj)=>
        return  {
            cid:obj._id
            name:obj.name
            link:@helper.url_for(obj.path)
            count: obj.length
            subs:[]
        }
    getByRoute:(arrays)=>
        now = @tree
        for name in arrays
            for sub in now.subs
                now = sub if name is sub.name
                break
        return now



array_cate_url = (url)->
    parts = url.split('/')
    result=[]
    for part in parts
        result.push(part) if part isnt '' and part isnt 'categories'
    return result

cateTrees =null
hexo.extend.helper.register 'm_list_cates',(url)->
     cateTrees = new CateTree(this.site.categories,this) unless cateTrees
     arrays=[]
     arrays = array_cate_url(url) if url
     if arrays.length is 0
         return cateTrees.tree.subs
     else
         return cateTrees.getByRoute(arrays).subs
hexo.extend.helper.register 'm_depth_cate',(cates)->
    result={name:'uncated'}
    cates.forEach (cate)=>
        result=cate
    return {
        name:result.name
        link:this.url_for(result.path)
        count: result.length
    }
    # query=(cid,tree)->
    #     if tree.cid is cid
    #         return tree
    #     for sub in tree.subs
    #         result=query(cid,sub)
    #         if result
    #             return result
    #     return null
    # makeInTree=(obj,cate)->
    #     return if query(obj._id,cateTrees)
    #     unless obj.parent
    #         cateTrees.subs.push(warpInTree(obj))
    #         return
    #     parent = query(obj.parent,cateTrees)
    #     parent = makeInTree(obj.parent,cate) unless parent
    #     parent.subs.push(warpInTree(obj))
    #
    # warpInTree=(obj)=>
    #     return  {
    #         cid:obj._id
    #         name:obj.name
    #         link:this.url_for(obj.path)
    #         count: obj.length
    #         subs:[]
    #     }




    # cates = this.site.categories unless cates
    # # console.log(cates)
    # result=[]
    # cates.forEach (cate)=>
    #     result.push {
    #         name:cate.name
    #         link:this.url_for(cate.path)
    #         count: cate.length
    #     }
    # return result

hexo.extend.helper.register 'm_list_tags',(tags)->
    tags = this.site.tags unless tags
    result=[]
    tags.forEach (tag)=>
        result.push {
            name:tag.name
            link:this.url_for(tag.path)
            count: tag.length
        }
    return result

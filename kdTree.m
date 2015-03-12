classdef kdTree
   properties
      node = {};
      leftChild
      rightChild
      splitFeature
      target
   end
   methods
      function obj = addValue(obj,point)
         obj.node = point;
      end
      function obj1 = addLeftChild(obj1,obj2)
            obj1.leftChild = obj2;
      end
      function obj1 = addRightChild(obj1,obj2)
            obj1.rightChild = obj2;
      end
      function obj = addSplitFeature(obj,feat)
         obj.splitFeature = feat;
      end
      function obj = addTarget(obj,target)
         obj.target = target;
      end
   end
end